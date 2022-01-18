//
//  ExerciseViewController.swift
//  JogoSubsidiary
//
//  Created by Muhammad Nauman on 24/10/2020.
//

import AVFoundation
import ReplayKit
import UIKit

@objc class ExerciseViewController: CameraViewController {
  // EVC is the base VC for all the exercises.
  // Class should house the UI logic only and interfacing logic between the CVC and other classes if needed.
  // Houses the RenderController and the UI related logic.
  
  enum ExerciseOrientation: String {
    case portrait
    case landscape
  }
  
  // MARK: Views
  @IBOutlet private var overlayView: UIView!
  var exerciseRenderView: ExerciseRenderView!
  static var viewRect: CGRect!
  
  // MARK: ViewControllingClasses
  
  var exerciseType: BaseExercise.Type?
  
  // MARK: Variables
  
  // This 1.2 seconds is just a decent buffer for all the Queues to clear up.
  // And a buffer so that the exercise does not calibrate immediately.
  let restartPauseTime: Double = 1.2
  
  // Calibration Image Mapping according to exercises
  var bodyRect: CGRect!
  var stopRect: CGRect?
  private var defaultCalibrationImage: String = "img_greenBodyAvatar"
  public var calibrationImageMap: [Int: String] = [Int: String]()
  
  // This locks the orientation of the exercise. Do not make this true.
  // For any UI related changes. Call the isOrientationLandscape function in the ViewController.
  var exerciseOrientation: ExerciseOrientation = .landscape
  var supportedInterfaces: UIInterfaceOrientationMask = [.landscapeRight]
  var autoRotate: Bool = false
  var renderViewRect = CGRect.zero
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return supportedInterfaces
  }
  
  override var shouldAutorotate: Bool {
    return autoRotate
  }
  
  // MARK: Exercise Reference
  var exercise: BaseExercise?
  @objc static var baseViewController: ExerciseViewController?
  
  func setStaticViewController() {
    if ExerciseViewController.baseViewController == nil {
      ExerciseViewController.baseViewController = self
    } else {
      Logger.shared.log(logType: .ERROR, message: "Previous exercise view controller has not been deinit properly.")
    }
  }
  
  // MARK: ViewController Lifecycle
  override func viewDidLoad() {
    setOrientation(value: UIInterfaceOrientation.landscapeRight.rawValue, eOrientation: .landscape)
    super.viewDidLoad()
    self.modalPresentationStyle = .fullScreen
    setUpViews()
    setStaticViewController()
    ExerciseViewController.viewRect = self.view.frame
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    UIApplication.shared.isIdleTimerDisabled = true
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.exerciseRenderView = ExerciseRenderView(frame: renderViewRect, eorientation: exerciseOrientation)
    self.exerciseRenderView.scoreView.isHidden = true
//    self.exerciseRenderView.progressionBar.isHidden = true
    self.view.addSubview(self.exerciseRenderView)
    
    if OldExerciseSettings.RECORD_MODE {
      self.startRecording()
    } else {
      self.startExercise()
      self.setCalibrationImage()
    }
    ExerciseViewController.viewRect = self.view.frame
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    overlayView.frame = renderViewRect
  }
  
  func startRecording() {
    RPScreenRecorder.shared().startCapture { sampleBuffer, bufferType, error in
      self.videoCapture?.screenRecorder.recordScreen(sampleBuffer: sampleBuffer, bufferType: bufferType, error: error)
    } completionHandler: { error in
      if error == nil {
        self.startExercise()
        self.setCalibrationImage()
      } else {
        self.startRecording()
      }
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    supportedInterfaces = [.landscapeRight, .portrait]
    setOrientation(value: UIInterfaceOrientation.portrait.rawValue, eOrientation: .portrait)
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    exercise?.stop()
    exerciseCompleteHelper()
    exercise = nil
    ExerciseViewController.baseViewController = nil
    UIApplication.shared.isIdleTimerDisabled = false
  }
  
  deinit {
    Logger.shared.log(logType: .INFO, message: "EVC Deinitializing")
  }
  
  // MARK: Exercise Lifecycle
  func startExercise() {
    self.exercise = self.getExercise()
    self.exercise?.start()
  }
  
  override func reset() {
    super.reset()
    self.exerciseRenderView.scoreView.setCount(score: "0", blink: false)
    self.exerciseRenderView.scoreView.isHidden = true
  }
  
  
  // MARK: Orientation Logic
  
  func setOrientation(value: Int, eOrientation: ExerciseOrientation) {
    UIDevice.current.setValue(value, forKey: "orientation")
    exerciseOrientation = eOrientation
  }
  
  // MARK: View setup logic.
  func switchViewsVisibility(switchGuideLbl: Bool = false, switchOverlayRef: Bool = false, switchOverlayView: Bool = false) {
    if switchGuideLbl {
      self.exerciseRenderView.getTextLbl().isHidden = !self.exerciseRenderView.getTextLbl().isHidden
    }
    if switchOverlayRef {
      self.overlayView.isHidden = !self.overlayView.isHidden
    }
    if switchOverlayView {
      self.overlayView.isHidden = !self.overlayView.isHidden
    }
  }
  
  func setUpViews() {
  }
  
  func setCalibrationImage() {
  }
  
  func addGraph(view: UIView) {
    self.exerciseRenderView.graphContainer.addSubview(view)
  }
  
  // MARK: Exercise logic specific functionality.
  func getName() -> String {
    return "ExerciseViewController"
  }
  
  func getExercise() -> BaseExercise? {
    return self.exerciseType?.init(exerciseSettings: exerciseSettings!)
  }
  
  @objc func setExercise(exerciseId: String) {
    self.exerciseType = ExerciseManager.shared.getExercise(id: exerciseId)
  }
  
  @objc func setExercise(exerciseFormatName: String) {
    self.exerciseType = ExerciseManager.shared.getExercise(formatName: exerciseFormatName)
  }
  
  override func nonExerciseProcesses() {
    self.exercise?.nonExerciseProcessing()
  }
  
  
  
  override func drawDetections() {
    self.exerciseDraw(canvas: overlayView)
  }
  
  func startTransition(calibrated: Bool) {
    DispatchQueue.main.async {
      if calibrated {
        guard  self.exercise?.calibration?.lottieCalibration != nil else {
          self.exercise?.getExerciseRenderModule().showCountdown()
          return
        }
        self.exercise?.calibration?.lottieCalibration?.playCalibratingFirstHalf { [weak self] in
          self?.exercise?.calibration?.lottieCalibration?.playCalibratingSecondHalf()
          self?.exercise?.calibration?.lottieCalibration?.playCalibrated { [weak self] in
            self?.exercise?.calibration?.lottieCalibration?.stopAll()
            self?.exercise?.getExerciseRenderModule().showCountdown()
          }
        }
      }
    }
  }
  
  override func onImageProcessed(infoBlob: InfoBlob) {
    guard self.exercise != nil else { return }
    self.exercise?.process(infoBlob: infoBlob)
  }
  
  // MARK: Native -> RN data sending functionality
  func exerciseCompleteHelper() {
    let body: [String: AnyObject]? = exercise?.sendInformationBackToRN()
    if body == nil {
      Logger.shared.log(logType: .ERROR, message: "Could not create create object for sending information back to RN")
    }
    IOSNativeApp.shared?.sendEventToReactNative(body!)
  }
  
  public func getCalibrationImage(exerciseVariation: Int) -> String {
    return self.calibrationImageMap[exerciseVariation] ?? self.defaultCalibrationImage
  }
  
  // MARK: Used for testing dynamic UI
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    Logger.shared.log(logType: .INFO, message: "This should never be called in any scenario.")
    self.interfaceOrientationChanged()
    super.viewWillTransition(to: size, with: coordinator)
    setCalibrationImage()
  }
  
  @objc func interfaceOrientationChanged() {
    self.videoCapture!.setInterfaceOrientation(orientation: UIApplication.shared.windows.first?.windowScene?.interfaceOrientation)
  }
}

extension ExerciseViewController {
  
  func removeLayers(canvas: UIView) {
    canvas.layer.sublayers?.removeAll()
  }
  
  func hiddenButtonRender(canvas: UIView) {
    DispatchQueue.main.async {
      if self.showHiddenButton {
        self.exerciseRenderView?.activate()
      } else if !self.showHiddenButton && !self.canShowHiddenButton {
        self.exerciseRenderView?.deactivate(immediate: true)
      } else if !self.showHiddenButton {
        self.exerciseRenderView?.deactivate()
      }
    }
  }
  
  func exerciseDraw(canvas: UIView) {
    // TEST: if this does not clear up use DispatchQueue.main for clear the canvas layer
    DrawingManager.get().textY = 8
    removeLayers(canvas: canvas)
    if OldExerciseSettings.DEBUG_MODE {
      exercise?.drawDebug(canvas: canvas)
    }
    exercise?.draw(canvas: canvas)
    hiddenButtonRender(canvas: canvas)
  }
}
