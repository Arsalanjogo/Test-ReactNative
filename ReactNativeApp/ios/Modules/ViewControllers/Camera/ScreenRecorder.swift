//
//  ScreenRecorder.swift
//  jogo
//
//  Created by Muhammad Nauman on 21/09/2021.
//

import Foundation
import AVFoundation
import ReplayKit

class ScreenRecorder {
  
  static var videoPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("video_\(Int(Date().getMilliseconds())).mp4")
  
  // File Writer
  fileprivate var videoWriter: AVAssetWriter!
  fileprivate var videoWriterInput: AVAssetWriterInput!
  fileprivate var audioWriterInput: AVAssetWriterInput!
  fileprivate var sessionAtSourceTime: CMTime?
  
  var frameDuration: CMTime!
  var imageWidth = 0
  var imageHeight = 0
  fileprivate(set) lazy var isRecording = false
  
  func setupWriter() {
    ScreenRecorder.updateVideoPath()
    do {
      if FileManager.default.fileExists(atPath: ScreenRecorder.videoPath.path) {
        try FileManager.default.removeItem(at: ScreenRecorder.videoPath)
      }
      videoWriter = try AVAssetWriter(url: ScreenRecorder.videoPath, fileType: .mp4)
      let screenSize = UIScreen.main.bounds
      let w: Int = Int(screenSize.width)
      let h: Int = Int(screenSize.height)

      imageWidth = w
      imageHeight = h
      // Add video input
      videoWriterInput = AVAssetWriterInput(mediaType: .video, outputSettings: [
        AVVideoCodecKey: AVVideoCodecType.h264,
        AVVideoWidthKey: w,
        AVVideoHeightKey: h,
        AVVideoCompressionPropertiesKey: [
          AVVideoAverageBitRateKey: 2300000,
        ],
      ])
      videoWriterInput.expectsMediaDataInRealTime = true // Make sure we are exporting data at realtime
      if videoWriter.canAdd(videoWriterInput) {
        videoWriter.add(videoWriterInput)
      }
      
      // If here, AVAssetWriter exists so create AVAssetWriterInputPixelBufferAdaptor
      
//      frameDuration = CMTimeMake(value: 1, timescale: videoWritingFPS)
      
      // Add audio input
      audioWriterInput = AVAssetWriterInput(mediaType: .audio, outputSettings: [
        AVFormatIDKey: kAudioFormatMPEG4AAC,
        AVNumberOfChannelsKey: 1,
        AVSampleRateKey: 44100,
        AVEncoderBitRateKey: 64000,
      ])
      audioWriterInput.expectsMediaDataInRealTime = true
      if videoWriter.canAdd(audioWriterInput) {
        videoWriter.add(audioWriterInput)
      }
      videoWriter.startWriting() // Means ready to write down the file
    } catch let error {
      Logger.shared.logError(error: error)
    }
  }
  
  private func exportWithWatermark() {
    
    // Getting asset
    guard FileManager.default.fileExists(atPath: ScreenRecorder.videoPath.path) else {
      DispatchQueue.main.async {
        ExerciseViewController.baseViewController?.dismiss(animated: true, completion: nil)
      }
      return
    }
    let asset = AVAsset(url: ScreenRecorder.videoPath)
    let composition = AVMutableComposition()
    composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
    let clipVideoTrack = asset.tracks(withMediaType: .video)[0]
    let videoSize = clipVideoTrack.naturalSize
    
    // Making Watermark
    let imgLogo = UIImage(named: "BootSplashLogo")
    let watermarkLayer = CALayer()
    watermarkLayer.contents = imgLogo?.cgImage
    let renderRect = ExerciseViewController.baseViewController!.renderViewRect
    watermarkLayer.frame = CGRect(x: renderRect.minX + 8, y: renderRect.height - 40 - 16 + renderRect.minY, width: 107, height: 40)
    watermarkLayer.opacity = 0.85
    
    // Adding the layers and making the format
    let videoComposition = AVMutableVideoComposition()
    videoComposition.renderSize = videoSize
    videoComposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
//          videoComposition.renderScale = 1.0
    let parentLayer = CALayer()
    let videoLayer = CALayer()
    parentLayer.frame = CGRect(x: 0, y: 0, width: videoSize.width, height: videoSize.height)
    videoLayer.frame = CGRect(x: 0, y: 0, width: videoSize.width, height: videoSize.height)
    parentLayer.addSublayer(videoLayer)
    parentLayer.addSublayer(watermarkLayer)
    videoComposition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayers: [videoLayer], in: parentLayer)
    let instruction = AVMutableVideoCompositionInstruction()
    instruction.timeRange = CMTimeRangeMake(start: .zero, duration: CMTimeMakeWithSeconds(60, preferredTimescale: 30))
    
    let transformer = AVMutableVideoCompositionLayerInstruction(assetTrack: clipVideoTrack)
    instruction.layerInstructions = [transformer]
    videoComposition.instructions = [instruction]
    
    // Exporting the video
    let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality)
    exporter?.outputFileType = .mp4
    let previousPath = ScreenRecorder.videoPath
    ScreenRecorder.updateVideoPath()
    exporter?.outputURL = ScreenRecorder.videoPath
    exporter?.videoComposition = videoComposition
    let loader = ExerciseViewController.baseViewController?.exerciseRenderView.activityIndicator
    DispatchQueue.main.async {
      ExerciseViewController.baseViewController?.view.bringSubviewToFront(loader!)
      loader?.startAnimating()
      loader?.isHidden = false
    }
    exporter?.exportAsynchronously(completionHandler: {
      if exporter?.status == .completed {
        print("Export complete")
        DispatchQueue.main.async {
          loader?.isHidden = true
          if FileManager.default.fileExists(atPath: previousPath.path){
            try? FileManager.default.removeItem(at: previousPath)
          }
          ExerciseViewController.baseViewController?.dismiss(animated: true, completion: nil)
        }
      }
    })
  }
  
  static func updateVideoPath() {
    ScreenRecorder.videoPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("video_\(Int(Date().getMilliseconds())).mp4")
  }
  
  func getThumbnail() -> UIImage? {
    do {
      let asset = AVURLAsset(url: ScreenRecorder.videoPath, options: nil)
      let imgGenerator = AVAssetImageGenerator(asset: asset)
      imgGenerator.appliesPreferredTrackTransform = true
      let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 1), actualTime: nil)
      let thumbnail = UIImage(cgImage: cgImage)
      return thumbnail
    } catch let error {
      Logger.shared.logError(error: error)
      return nil
    }
  }
  
  fileprivate func canWrite() -> Bool {
    return isRecording
      && videoWriter != nil
      && videoWriter.status == .writing
  }
  
  func deleteFileIfEmpty() {
    if FileManager.default.fileExists(atPath: ScreenRecorder.videoPath.path) {
      guard let attributes = try? FileManager.default.attributesOfItem(atPath: ScreenRecorder.videoPath.path) else { return }
      if let fileSize = attributes[.size] as? UInt64, fileSize == 0 {
        try? FileManager.default.removeItem(at: ScreenRecorder.videoPath)
      }
    }
  }
  
  func start() {
    guard !isRecording else { return }
    isRecording = true
    sessionAtSourceTime = nil
  }
  
  func reset() {
    self.setupWriter()
  }
  
  func stop() {
    self.stopRecording()
    guard isRecording else {
      deleteFileIfEmpty()
      return
    }
    isRecording = false
  }
  
  func stopRecording() {
    RPScreenRecorder.shared().stopCapture { _ in
      if self.videoWriter.status == .writing {
        self.videoWriter.finishWriting { [weak self] in
          self?.sessionAtSourceTime = nil
          self?.deleteFileIfEmpty()
          self?.exportWithWatermark()
          
        }
      }
    }
  }
  
  func recordScreen(sampleBuffer: CMSampleBuffer, bufferType: RPSampleBufferType, error: Error?) {
    guard canWrite() else {
      return
    }
    if CMSampleBufferDataIsReady(sampleBuffer) {
      if self.sessionAtSourceTime == nil {
        self.sessionAtSourceTime = CMSampleBufferGetPresentationTimeStamp(sampleBuffer)
        self.videoWriter.startSession(atSourceTime: self.sessionAtSourceTime!)
      }
      if bufferType == .video {
        if self.videoWriterInput.isReadyForMoreMediaData {
          self.videoWriterInput.append(sampleBuffer)
        }
    }
      if bufferType == .audioApp {
        if self.audioWriterInput.isReadyForMoreMediaData {
          self.audioWriterInput.append(sampleBuffer)
        }
      }
    }
  }
  
  
}
