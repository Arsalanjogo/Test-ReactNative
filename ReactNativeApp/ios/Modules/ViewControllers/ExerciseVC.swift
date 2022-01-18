//
//  ExerciseVC.swift
//  jogo
//
//  Created by Mohsin on 14/10/2021.
//

import UIKit
import AVFoundation


public enum GameState {
  case NORMAL
  case RESTART
}

internal struct PayLoad: Codable {
  var payload: String
  var duration: Double
  var orientation: String
  var camera: Bool
}

class ExerciseVC: UIViewController, IOStream, VideoCaptureDelegate, CleanupProtocol, GameEndDelegate {
  
  // MARK: Force Orientation Setup
  var supportedInterfaces: UIInterfaceOrientationMask = [.landscapeRight, .portrait]
  var autoRotate: Bool = false
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask { return supportedInterfaces }
  override var shouldAutorotate: Bool { return autoRotate }
  
  var exiting = false
  var gameState: GameState = .NORMAL
  var cameraPosition: CameraFacing?

  private var renderLoop: RenderLoop!
  private var phaseManager: PhaseManager?
  private var gameContext: GameContext!
  private var counter: Counter? = Counter()
  
  @objc public var payload: String?
  
  fileprivate var exerciseInformation: PayLoad!
  
  internal var videoCapture: CameraCapture?
  internal var videoReader: VideoReader?
  
  func setUpPayLoad() {
    do {
      let data = payload?.data(using: .utf8)
      self.exerciseInformation = try JSONDecoder().decode(PayLoad.self, from: data!)
    } catch {
      Logger.shared.log(logType: .DEBUG, message: "Cannot decipher data, \(self.payload ?? "")")
    }
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpPayLoad()
    if exerciseInformation.orientation == "PORTRAIT" {
      supportedInterfaces = [.portrait]
    } else {
      supportedInterfaces = [.landscapeRight]
    }
    setupContext()
    setupGamePhases()
    view.backgroundColor = .black
    if self.exerciseInformation.camera {
      self.videoCapture = CameraCapture()
      self.videoCapture!.delegate = self
    } else {
      self.videoReader = VideoReader(videoPath: "videos/test_video5.MOV")
      self.videoReader?.delegate = self
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    UIApplication.shared.isIdleTimerDisabled = true
    if exerciseInformation.camera {
      self.setUpVideoCapture()
    } else {
      self.setupVideoReading()
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    renderLoop = RenderLoop(frame: self.view.frame)
    self.view.addSubview(renderLoop)
    renderLoop.start()
    phaseManager?.start()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    RenderLoop.cleanup()
    let body = self.collateGameInformation()
    IOSNativeApp.shared?.sendEventToReactNative(body!)
    ExerciseStatsJsonManager.remove()
  }
  
  public func cleanup() {
    self.renderLoop.stopDrawThread()
    self.phaseManager?.stop()
    self.stopVideoCapture()
    self.phaseManager = nil
    DrawingManager.remove()
    SoundManager.remove()
    SpeechManager.remove()
  }
  
  deinit {
    
  }
  
  func dismissGame() {
    // MARK: @Nauman use this method for RN data transfer etc.
    // Before Cleanup i.e.
    self.cleanup()
    self.dismiss(animated: true, completion: nil)
  }
  
  func setupVideoReading() {
    self.videoReader?.setUpPreviewView(view: self.view, cameraPosition: .back)
    self.videoReader?.startReadingFrames()
  }
  
  func setUpVideoCapture() {
    self.cameraPosition = gameContext.cameraFacing!
    videoCapture?.setupSession(on: self.view, position: gameContext.cameraFacing!) { [unowned self] (granted) in
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
    videoCapture?.setInterfaceOrientation(orientation: UIApplication.shared.windows.first?.windowScene?.interfaceOrientation)
  }
  
  func setupContext() {
    // TODO: Add the value of the filename received from the RN side.
    gameContext = GameContext(gameInformation: exerciseInformation, exerciseVC: self)
  }
  
  func setupGamePhases() {
    phaseManager = PhaseManager(gameEndDelegate: self)
  }
  
  func onImageProcessed(infoBlob: InfoBlob) {
    gameContext.setInfoBlob(value: infoBlob)
  }
  
  @objc internal func doSomething() {
    self.viewWillAppear(true)
  }
  
  // MARK: CameraCapture Interface
  func stopVideoCapture() {
    self.videoCapture?.stop()
  }
  
  func reset() {
    self.videoCapture?.stop()
    self.videoCapture?.reset()
  }
  
  func startVideoCapture() {
    self.videoCapture?.start()
  }
  
  func insertInfoIntoExerciseJson() {
    ExerciseStatsJsonManager.get().setCameraInfo(frameId: counter!.counterValue(),
                                                 timeStamp: (Date().getMilliseconds() - (self.gameContext.exerciseTime ?? 10_000_000) ).n_dp_str())
  }
  
  // MARK: VideoCaptureDelegate
  func didReceiveFrame(frame: CMSampleBuffer, orientation: UIImage.Orientation) {
    // Simple delegate called on each frame captured from the camera.
    // Called from the CameraCapture class.
    // Creates the ESB and sends that to the model manager.
    // Instantiates another cycle of the drawing logic.
    guard let _context = self.gameContext else { return }
    guard let _counter = self.counter else { return }
    
    _counter.increment()
    _context.setCurrentFrameNumber(value: _counter.counterValue())
    
    if exiting { return }
    if gameState == .RESTART { return }
    let extendedSampleBuffer = ExtendedSampleBuffer(image: frame,
                                                    frameID: _counter.counterValue(),
                                                    screenOrientation: orientation.rawValue,
                                                    isBackCamera: (cameraPosition == CameraFacing.BACK),
                                                    cameraOrientation: orientation)
    guard let _modelManager = _context.modelManager else { return }
    if _modelManager.exiting { return }
    
    self.insertInfoIntoExerciseJson()
    Profiler.get().profileTemp(frameId: _counter.counterValue())
    Profiler.get().profileMemory(frameId: _counter.counterValue())
    _modelManager.supplyFrame(sampleBuffer: extendedSampleBuffer)
  }
  
  // MARK: Back to React Native Functionality
  private func collateGameInformation() -> [String: AnyObject]? {
    let eTime: Double = Date().getMilliseconds()
    let sTime: Double = self.gameContext.exerciseTime ?? eTime
    let completion_time: Double = eTime - sTime
    var final_score: Int = 0
    var question_score: Int = 0
    let videoPath: String = ScreenRecorder.videoPath.absoluteString
    do {
      final_score = self.gameContext.currentScore
    } catch {
      Logger.shared.logError(logType: .ERROR, error: error, extraMsg: "Score fetching error!")
    }
    

    let data: ExerciseCompleteHelper = ExerciseCompleteHelper(
      videoPath: videoPath,
      score: ExerciseCompleteHelperScore(final_score: "\(final_score)"),
      json_path: ExerciseStatsJsonManager.get().getExerciseJsonPath().absoluteString,
      exercise_name: self.gameContext.gamePhaseName?.rawValue ?? "",
      completion_time: "\(completion_time)",
      questions: nil)

    let encoder: JSONEncoder = JSONEncoder()
    do {
      let info = try encoder.encode(data)
      let dictionary = try JSONSerialization.jsonObject(with: info, options: .allowFragments) as? [String: AnyObject]
      return dictionary
    } catch {
      Logger.shared.logError(logType: .ERROR, error: error, extraMsg: "Bad JSON could not be serialized!")
    }
    return nil
  }

}
