//
//  CameraViewController.swift
//  jogo
//
//

import AVFoundation
import UIKit

// MARK: CameraViewController
@objc class CameraViewController: UIViewController, VideoCaptureDelegate, IOStream {
  
  // CVC houses the logic of the camera, sensor and associated core device related hardware.
  // This is the main class which is inherited by the ExerciseViewController.
  // The Model Manager class is referenced in this.
  // Frames are passed along this class to the model manager.
  // CameraCapture -> CVC -> Model Manager.
  
  public enum SetUpSession {
    case DONE
    case UNAVAILABLE_RESOLUTION
    case GRANT_PERMISSION
  }
  
  public enum ExerciseState {
    case NORMAL
    case RESTART
  }
  
  // MARK: Variables
  var willStartRecord = false
  var timeSec = 0.0
  var showHiddenButton: Bool = false
  var exiting = false
  @objc public var payload: String?
  var cameraPosition: CameraFacing?
  var cameraOrientation: AVCaptureDevice.Position?
  var drawingFrameDifference: Int = 30 / OldExerciseSettings.DRAWING_FPS
  var frameToDrawOn: Int = 0
  var exerciseState: ExerciseState = .NORMAL
  
  // MARK: Objects:
  internal var videoCapture: CameraCapture? = CameraCapture()
  private var counter: Counter? = Counter()
  var modelManager: ModelManager?
  var exerciseSettings: OldExerciseSettings?
  weak var sensorManagerRef: SensorManager?
  var canShowHiddenButton: Bool = true
  
  // MARK: Other Variables
  var timer: TimerUtil? = TimerUtil(throwException: false)
  
  // MARK: Queues
  var cvcOtherDataProcessingQueue: DispatchQueue = DispatchQueue(label: "cvcOtherDataProcessingQueue",
                                                                 qos: .utility,
                                                                 attributes: [],
                                                                 autoreleaseFrequency: .inherit,
                                                                 target: .global(qos: .utility))
  
  // MARK: Lifecycle
  
  override func viewDidLoad() {
    // Create ModelManager and set up camera nad sensors for use in the exercise.
    super.viewDidLoad()
    self.frameToDrawOn = drawingFrameDifference
    self.setUpSettings()
//    self.modelManager = ModelManager.createInstance(ioStream: self)
    self.videoCapture!.delegate = self
    self.setUpSensorManager()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    // Start the camera and ask permission if not given.
    Logger.shared.setRunId()
    super.viewWillAppear(animated)
    UIApplication.shared.isIdleTimerDisabled = true
    self.setUpVideoCapture()
  }
  
  func setUpVideoCapture() {
    videoCapture?.setupSession(on: self.view, position: cameraPosition!) { [unowned self] (granted) in
      switch granted {
      case .GRANT_PERMISSION:
        NotificationCenter.default.addObserver(self, selector: #selector(self.doSomething), name: UIApplication.willEnterForegroundNotification, object: nil)
        let alertVC = UIAlertController(title: "Oops!", message: "Please grant camera permission from settings to use this feature", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
      case .UNAVAILABLE_RESOLUTION:
        NotificationCenter.default.addObserver(self, selector: #selector(self.doSomething), name: UIApplication.willEnterForegroundNotification, object: nil)
        let alertVC = UIAlertController(title: "Oops!", message: "Camera is not suitable for Jogo to run properly.", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
      case .DONE:
        NotificationCenter.default.removeObserver(self)
      }
    }
    
    // Initially setup the orientation of the current exercise.
    // There are 2 available rotations for the exercise outside here.
    // You can put the view in the orientation before the the exercise is started.
    // When the exercise starts, rotation is locked and the orientation of the camera
    // is locked with the image orientation locked for the mode.
    // The only dynamic ass thing here is that before starting the exercise, choose your orientation and that is that.
    videoCapture!.setInterfaceOrientation(orientation: UIApplication.shared.windows.first?.windowScene?.interfaceOrientation)
  }
  
  @objc internal func doSomething() {
    self.viewWillAppear(true)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    // For model output scaling.
    super.viewDidAppear(animated)
    ObjectDetection.screenSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
  }
  
  override func   viewDidDisappear(_ animated: Bool) {
    // Remove and dereference all objects so that nothing persists between exercises.
    super.viewDidDisappear(animated)
    self.exiting = true
    self.stopVideoCapture()
    self.sensorManagerRef?.deinitialize()
    SensorManager.removeInstance()
    self.videoCapture = nil
    modelManager!.exit()
    modelManager = nil
    ModelManager.removeInstance()
    
    counter = nil
    IResolve.cleanup()
    BaseExercise.baseExercise = nil
    Logger.shared.clearMaps()
    Logger.shared.log(logType: .INFO, message: "CVC Disappeared")
    UIApplication.shared.isIdleTimerDisabled = false
  }
  
  deinit {
    Logger.shared.log(logType: .INFO, message: "CVC deinit")
  }
  
  // MARK: Class Setup Logic
  
  private func setUpSensorManager() {
    sensorManagerRef = SensorManager.createInstance()
    sensorManagerRef?.initialize(gyro: true)
  }
  
  public func setUpSettings() {
    do {
      let data = payload?.data(using: .utf8)
      self.exerciseSettings = try OldExerciseSettings(settings: data)
      self.cameraPosition = self.exerciseSettings!.getCameraFacing()
    } catch {
      Logger.shared.logError(logType: .ERROR, error: error, extraMsg: "Payload from RN side is BAD!")
    }
  }
  
  public func setModelManager() {
//    self.modelManager = ModelManager.createInstance(ioStream: self)
  }
  
  // MARK: Device hardware check
  
  public func getCameraFacing() -> CameraFacing {
    return cameraPosition!
  }
  
  public func getCameraOrientation() -> AVCaptureDevice.Position {
    return cameraOrientation!
  }
  
  // MARK: CameraCapture Interface
  func stopVideoCapture() {
    self.videoCapture?.stop()
    self.counter?.reset()
  }
  
  func reset() {
    self.frameToDrawOn = self.drawingFrameDifference
    self.timeSec = 0
    self.videoCapture?.stop()
    self.videoCapture?.reset()
    self.counter?.reset()
  }
  
  func startVideoCapture() {
    self.videoCapture?.start()
  }
  
  public func getCurrentFrameValue() -> Int {
    return counter!.counterValue()
  }
  
  // MARK: Get Thumbnail from CameraCapture
  func getThumbnail() -> Data {
    return videoCapture!.screenRecorder.getThumbnail()?.jpegData(compressionQuality: 0.5) ?? Data()
  }
  
  // MARK: VideoCaptureDelegate
  func didReceiveFrame(frame: CMSampleBuffer, orientation: UIImage.Orientation) {
    // Simple delegate called on each frame captured from the camera.
    // Called from the CameraCapture class.
    // Creates the ESB and sends that to the model manager.
    // Instantiates another cycle of the drawing logic.
    // if (ExerciseViewController.baseViewController?.exerciseState ?? .RESTART) == .RESTART { return }
    if counter == nil { return }
    counter!.increment()
    
    if exiting { return }
    if exerciseState == .RESTART { return }
    let extendedSampleBuffer = ExtendedSampleBuffer(image: frame,
                                                    frameID: counter!.counterValue(),
                                                    screenOrientation: orientation.rawValue,
                                                    isBackCamera: (cameraPosition == CameraFacing.BACK),
                                                    cameraOrientation: orientation)
    if modelManager == nil { return }
    if modelManager!.exiting { return }
    
    if !(BaseExercise.getExercise()?.running ?? true) { return }
    
    self.insertInfoIntoExerciseJson()
    modelManager?.supplyFrame(sampleBuffer: extendedSampleBuffer)
    
    cvcOtherDataProcessingQueue.async { [weak self] in
      self?.showHiddenButton = self?.sensorManagerRef?.isDeviceBeingHandled() ?? false
    }
    
    if counter!.counterValue() == frameToDrawOn {
      DispatchQueue.main.sync { [weak self] in
        guard self != nil else { return }
        self!.drawDetections()
        self!.frameToDrawOn += self!.drawingFrameDifference
      }
    }

    self.nonExerciseProcesses()
  }
  
  func insertInfoIntoExerciseJson() {
    ExerciseStatsJsonManager.get().setCameraInfo(frameId: counter!.counterValue(),
                                                 timeStamp: (Date().getMilliseconds() - (BaseExercise.getExercise()?.exerciseTime ?? 10_000_000) ).n_dp_str())
  }
  
  func drawDetections() { }
  
  func nonExerciseProcesses() { }
  
  // MARK: IOStream
  func onImageProcessed(infoBlob: InfoBlob) {
  }
  
}
