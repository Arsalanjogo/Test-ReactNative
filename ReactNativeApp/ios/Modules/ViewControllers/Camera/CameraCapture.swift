//
//  VideoCapture.swift
//  JogoSubsidiary
//
//  Created by Muhammad Nauman on 24/10/2020.
//  Copyright © 2020 Muhammad Nauman. All rights reserved.
//

import AVFoundation
import CoreMedia
import Foundation
import ReplayKit
import UIKit
import VideoToolbox

class CameraCapture: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate {
  // Houses logic for the Camera setup and video file writing.
  // Camera resolution, orientation and location.
  // Video file resolutionm orientation and file location.
  // Convert the frame and send it along to the CVC.
  
  // MARK: Variables
  
  var chosenCameraResolution: String = "default"
  var chosenFrameRate: Double = 30
  var interfaceOrientation: UIInterfaceOrientation!
  fileprivate var cameraPosition: AVCaptureDevice.Position = AVCaptureDevice.Position.unspecified
  
  let no_resolution_error: String = "The lowest available resolution required for the application is unavailable for this camera."
  let authorization_error: String = "Needs authorization."
  
  // Camera Related
  fileprivate lazy var cameraSession = AVCaptureSession()
  fileprivate lazy var videoDataOutput = AVCaptureVideoDataOutput()
  fileprivate lazy var audioDataOutput = AVCaptureAudioDataOutput()
  
  //  var videoWritingFPS: Int32 = 15
  var screenRecorder = ScreenRecorder()
  
  var frameCount = 0
  
  var previewCropTolerance: CGFloat = 0
  
  // Delegate
  weak var delegate: VideoCaptureDelegate?
  
  // MARK: Initialization and Setup
  
  func setupSession(on view: UIView,
                    position: CameraFacing,
                    completion: @escaping (CameraViewController.SetUpSession) -> Void) {
    // Checks permissions, sets the camera, returns good if everything ok, otherwise, bad output.
    switch AVCaptureDevice.authorizationStatus(for: .video) {
    case .notDetermined:
      AVCaptureDevice.requestAccess(for: .video) { granted in
        DispatchQueue.main.async {
          if granted {
            self.screenRecorder.setupWriter()
            let setUpComplete: Bool = self.setupCamera(in: view, position: position)
            if setUpComplete { completion(.DONE) } else {
              completion(.UNAVAILABLE_RESOLUTION)
              Logger.shared.log(logType: .ERROR, message: self.no_resolution_error)
            }
          }
          completion(.DONE)
        }
      }
    case .restricted:
      completion(.GRANT_PERMISSION)
    case .denied:
      completion(.GRANT_PERMISSION)
    case .authorized:
      DispatchQueue.main.async {
        self.screenRecorder.setupWriter()
        let setUpComplete: Bool = self.setupCamera(in: view, position: position)
        if setUpComplete { completion(.DONE) } else {
          completion(.UNAVAILABLE_RESOLUTION)
          Logger.shared.log(logType: .ERROR, message: self.no_resolution_error)
        }
      }
    default:
      completion(.GRANT_PERMISSION)
      Logger.shared.log(logType: .ERROR, message: self.authorization_error)
    }
  }
  
  @discardableResult
  fileprivate func setupCamera(in view: UIView, position: CameraFacing) -> Bool {
    // Setup your camera
    // Detect which type of camera should be used via `isUsingFrontFacingCamera`
    let camposition = getOrientation(position: position)
    cameraPosition = camposition
    guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: camposition) else {
      return true
    }
    
    var resolutionSet: Bool = false
    if captureDevice.supportsSessionPreset(cameraResolutions[usableResolutions[0]]!) {
      cameraSession.sessionPreset = cameraResolutions[usableResolutions[0]]!
      Logger.shared.log(logType: .DEBUG, message: "\(usableResolutions[0])")
      resolutionSet = true
      chosenCameraResolution = usableResolutions[0]
    }
    if !resolutionSet {
      return false
    }
    
    captureDevice.set(frameRate: self.chosenFrameRate)
    
    // Setup your microphone
    guard let audioDevice = AVCaptureDevice.default(for: .audio) else {
      return true
    }
    
    do {
      cameraSession.beginConfiguration()
      
      // Add camera to your session
      let deviceInput = try AVCaptureDeviceInput(device: captureDevice)
      if cameraSession.canAddInput(deviceInput) {
        cameraSession.addInput(deviceInput)
      }
      
      // Add microphone to your session
      let audioInput = try AVCaptureDeviceInput(device: audioDevice)
      if cameraSession.canAddInput(audioInput) {
        cameraSession.addInput(audioInput)
      }
      
      // Now we should define your output data
      let queue = DispatchQueue(label: "data-output")
      
      // Define your video output
      videoDataOutput.videoSettings = [
        kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA,
      ]
      videoDataOutput.alwaysDiscardsLateVideoFrames = true
      if cameraSession.canAddOutput(videoDataOutput) {
        videoDataOutput.setSampleBufferDelegate(self, queue: queue)
        cameraSession.addOutput(videoDataOutput)
      }
      
      // Define your audio output
      if cameraSession.canAddOutput(audioDataOutput) {
        audioDataOutput.setSampleBufferDelegate(self, queue: queue)
        cameraSession.addOutput(audioDataOutput)
      }
      
      cameraSession.commitConfiguration()
      
      // Present the preview of video
      setUpPreviewView(view: view, cameraPosition: camposition)
      
      // Don't forget start running your session
      // this doesn't mean start record!
      cameraSession.startRunning()
    } catch let error {
      Logger.shared.logError(error: error)
    }
    return true
  }
  
  func setUpPreviewView(view: UIView, cameraPosition: AVCaptureDevice.Position) {
    let previewLayer = AVCaptureVideoPreviewLayer(session: cameraSession)
    
    switch GameContext.getContext()?.applicationOrientation {
    case .LANDSCAPE:
      switch UIDevice.current.userInterfaceIdiom {
      case .pad:
        previewCropTolerance = 100
        previewLayer.frame = view.frame.insetBy(dx: 0, dy: previewCropTolerance / 2)
      default:
        previewCropTolerance = 130
        previewLayer.frame = view.frame.insetBy(dx: previewCropTolerance / 2, dy: 0)
      }
    case .PORTRAIT:
      previewLayer.frame = view.frame
    case .none:
      previewLayer.frame = view.frame
    }
    
    ObjectDetectionState.screenSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    
    if interfaceOrientation.isLandscape {
      previewLayer.connection?.videoOrientation = .landscapeRight
      if cameraPosition == .front {
        if previewLayer.connection?.isVideoMirroringSupported ?? false {
          previewLayer.connection?.automaticallyAdjustsVideoMirroring = false
          previewLayer.connection?.isVideoMirrored = true
        }
      }
      setScale(isLandscape: true)
    } else {
      previewLayer.connection?.videoOrientation = .portrait
      setScale(isLandscape: false)
    }
    previewLayer.videoGravity = .resizeAspectFill
    view.backgroundColor = .black
    view.layer.insertSublayer(previewLayer, at: 0)
  }
  
  func start() {
    screenRecorder.start()
  }
  
  func reset() {
    screenRecorder.setupWriter()
  }
  
  // MARK: Stopping
  
  deinit {
    //    self.stop()
    self.delegate = nil
  }
  
  func stop() {
    self.screenRecorder.stop()
  }
  
  public func getOrientation(position: CameraFacing) -> AVCaptureDevice.Position {
    var camposition = AVCaptureDevice.Position.unspecified
    switch position {
    case CameraFacing.FRONT:
      camposition = AVCaptureDevice.Position.front
    case CameraFacing.BACK:
      camposition = AVCaptureDevice.Position.back
    case CameraFacing.BOTH:
      print("To be implemented!")
    }
    return camposition
  }
  
  // MARK: Utility
  
  func setScale(isLandscape: Bool) {
    var imageWidth: CGFloat
    var imageHeight: CGFloat
    if isLandscape {
      let device = UIDevice.current
      imageWidth = device.userInterfaceIdiom == .pad ? UIScreen.main.bounds.width : UIScreen.main.bounds.width - previewCropTolerance
      imageHeight = device.userInterfaceIdiom == .pad ? UIScreen.main.bounds.height - previewCropTolerance : UIScreen.main.bounds.height
    } else {
      imageWidth = UIScreen.main.bounds.height
      imageHeight = UIScreen.main.bounds.width
    }
    
    let imageViewWidth: CGFloat = UIScreen.main.bounds.width
    let imageViewHeight: CGFloat = UIScreen.main.bounds.height
    
    let xScale = imageViewWidth / imageWidth
    let yScale = imageViewHeight / imageHeight
    
    ObjectDetectionState.xScale = Double(xScale)
    ObjectDetectionState.yScale = Double(yScale)
  }
  
  func setScale(width: CGFloat, height: CGFloat) {
    let imageViewWidth: CGFloat = UIScreen.main.bounds.width
    let imageViewHeight: CGFloat = UIScreen.main.bounds.height
    
    let xScale = imageViewWidth / width
    let yScale = imageViewHeight / height
    
    ObjectDetectionState.xScale = Double(xScale)
    ObjectDetectionState.yScale = Double(yScale)
    
  }
  
  // MARK: Image Orientation Logic
  
  func imageOrientation(
    deviceOrientation: UIDeviceOrientation,
    cameraPosition: AVCaptureDevice.Position
  ) -> UIImage.Orientation {
    // Gets the image orientation according to the device orientation and the camera selected.
    // There are 2 camera positions: front and back.
    // There are 4 useful device orientations: portraint, upsideDownPortrait, landScapeLeft, landScapeRight.
    // Thus 8 image orientations are defined. 4*2.
    if self.interfaceOrientation == .portrait {
      return cameraPosition == .front ? .leftMirrored : .right
    } else {
      return cameraPosition == .front ? .upMirrored : .down
    }
    // Look into previous commits for more verbose implementation if the more orientations are needed.
  }
  
  func getInterfaceOrientation() -> UIInterfaceOrientation? {
    return self.interfaceOrientation
  }
  
  func setInterfaceOrientation(orientation: UIInterfaceOrientation?) {
    if orientation == nil {
      return
    }
    self.interfaceOrientation = orientation!
  }
  
  // MARK: AVCaptureVideoDataOutputSampleBufferDelegate
  
  func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    
    guard CMSampleBufferDataIsReady(sampleBuffer) else { return }
    
    // Extra measure for scaling of points and exits iteration if sample buffer no image in it.
    guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
      return
    }
    self.delegate?.didReceiveFrame(frame: sampleBuffer,
                                   orientation: self.imageOrientation(deviceOrientation: UIDevice.current.orientation,
                                                                      cameraPosition: cameraPosition)
    )
    var copyBuffer: CVImageBuffer!
    autoreleasepool {
      copyBuffer = imageBuffer.copy()
    }
    
    let imageWidth = CGFloat(CVPixelBufferGetWidth(copyBuffer))
    let imageHeight = CGFloat(CVPixelBufferGetHeight(copyBuffer))
    setScale(width: imageWidth, height: imageHeight)
    
    if output == videoDataOutput {
      switch interfaceOrientation {
      case .landscapeRight:
        connection.videoOrientation = .landscapeRight
      case .landscapeLeft:
        connection.videoOrientation = .landscapeLeft
      case .portrait:
        connection.videoOrientation = .portrait
      case .portraitUpsideDown:
        connection.videoOrientation = .portraitUpsideDown
      default:
        connection.videoOrientation = .portrait
      }
    }
  }
}
