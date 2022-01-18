//
//  BaseExercise.swift
//  jogo
//
//  Created by Muhammad Nauman on 06/11/2020.
//

import AVFoundation
import Foundation
import UIKit

enum BaseExerciseErrors: Error {
  case AlreadyExistsError
}

protocol ExerciseProtocol {
  associatedtype VariationType: RawRepresentable
  static var variationT: VariationType { get set }
}

class BaseExercise {

  // Houses the main logic of the generic Exercise.

  // Inherited by Person, BallPerson and Ball Exercise.
  // Connects the Score, Calibration and EVC Objects together.
  // Houses pipeline of frames for Model Processing and Drawing.
  
  public enum STATUS: String {
    case NOT_STARTED = "Not Started"
    case CALIBRATION = "Calibration"
    case COUNTDOWN = "Countdown"
    case EXERCISE = "Exercise"
  }


  // MARK: Variables

  internal var status: STATUS = .NOT_STARTED
  internal static  var drawDebugYHeight: Int = 30
  internal static var drawDebugYStart: Int = 50
  public var xValue: Int = 20
  
  internal var waitExerciseFlag: Bool = true
  internal var objectInScreenCheckEnabled: Bool = true
  
  private var detectionsPaused: Bool = false
  private var inFrameLastUpdatedTime: Double = Date().getMilliseconds()
  private let OBJECTS_UNDETECTED_TIME_WINDOW: Double = 2000
  
  internal var running: Bool = true
  private var averageCts: [Double]?
  private var frameCounter: Int?
  internal var exerciseTime: Double?
  internal var startTime: Double?
  
  internal final var infoBlobArrayList: UtilArrayList<InfoBlob> = UtilArrayList<InfoBlob>()
  internal final var objectDetections: [ObjectDetection] = [ObjectDetection]()
  internal final let BOUNDING_BOX_TIMEOUT: Double = 6
  
  // JSON information
  public var exerciseJsonManager: ExerciseStatsJsonManager = ExerciseStatsJsonManager.get()
  
  // MARK: Objects
  internal var timer: TimerUtil = TimerUtil(throwException: false)
  internal static var baseExercise: BaseExercise?
  internal var calibration: Calibration?
  weak private final var baseViewController: ExerciseViewController?
  private final var exerciseRenderModule: ExerciseRenderModule?
  internal var exerciseSettings: OldExerciseSettings?
  public var questionManager: QuestionManager?
  public var score: BaseScore?
  
  // MARK: Lifecycle
  
  // Graph
  let graph = Graph(type: .line)
  
  required init(exerciseSettings: OldExerciseSettings) {
    
  }
  
  init(calibration: Calibration?, exerciseSettings: OldExerciseSettings) {
    // Set references and create the exercise render module.
    // Create the RenderModule and the BaseScore and set self as main exercise, otherwise, crash the app.
    // Lol. How about exiting gracefully, instead.
    if ExerciseViewController.baseViewController == nil { return }
    baseViewController = ExerciseViewController.baseViewController!
    self.calibration = calibration
    self.exerciseRenderModule = ExerciseRenderModule(viewController: baseViewController!, exercise: self, settings: exerciseSettings)
    do {
      try setBaseExercise()
    } catch {
      Logger.shared.logError(logType: .ERROR, error: error, extraMsg: "Unable to set BaseExercise!")
    }
    self.exerciseSettings = exerciseSettings
    self.score = self.exerciseSettings!.createScore(baseExercise: self)
    self.calibration = calibration
    calibration?.setBaseExercise(baseExercise: self)
    self.exerciseRenderModule?.startPromo()
    baseViewController!.addGraph(view: graph.view)
  }
  
  deinit {
    // Perform stuff here when this object is being dereferenced.
    Logger.shared.log(logType: .INFO, message: "deinit base exercise")
  }
  
  func reset() {
    self.running = false
    self.questionManager?.end()
    self.questionManager = nil
    self.status = .CALIBRATION
    self.calibration?.reset()
    self.score?.resetScore()
    self.exerciseTime = Date().getMilliseconds()
    self.exerciseJsonManager.resetExerciseJSON()
    self.running = true
  }
  
  private func setBaseExercise() throws {
    // There is room for only one exercise in town.
    if BaseExercise.baseExercise == nil {
      BaseExercise.baseExercise = self
    } else {
      Logger.shared.log(logType: .ERROR, message: "Exercise Already Exists")
      throw BaseExerciseErrors.AlreadyExistsError
    }
  }
  
  // MARK: Exercise Lifecycle
  internal func initExercise() {}
  
  public func startMainExercise() {
    // Normal operations for initializing the exercise.
    exerciseRenderModule?.toggleGraphVisibility(hide: false)
    initExercise()
    score!.start()
    if exerciseSettings?.usingQuestion() ?? false {
      questionManager = createQuestionManager(score: score!, questionEngine: createQuestionEngine())
      questionManager?.start()
    }
    waitExerciseFlag = false
    exerciseTime = Date().getMilliseconds()
    status = .EXERCISE
  }
  
  public func start() {
    // Show promo i.e. the countdown and on the callback at the end of the lottie animation,
    // start the exercise.
    running = true
  }
  
  public func onCalibrated() {
    // Start exercise logic when done calibrating.
    exerciseRenderModule?.startExercise()
  }
  
  @objc public func stop() {
    // Set the exercise as stopped.
    // Sever connection between observers and observed models.
    // Stop the score.
    // Create the exercise JSON.
    guard running else {
      return
    }
    LottieManager.get().stopAll { [weak self] in
      self?.endExercise()
      self?.exerciseRenderModule?.finish()
    }
  }
  
  @objc public func stop(endVC: Bool = true) {
    // Set the exercise as stopped.
    // Sever connection between observers and observed models.
    // Stop the score.
    // Create the exercise JSON.
    guard running else {
      return
    }
    self.endExercise()
    if endVC {
      exerciseRenderModule?.finish()
    }
  }
  
  public func endExercise() {
    guard running else {
      return
    }
    running = false
    objectDetections.forEach { (objectDetections) in
      objectDetections.unsubscribe()
    }
    exerciseRenderModule?.toggleGraphVisibility(hide: true)
    score?.stop()
    questionManager?.stop()
    questionManager?.end()
    PersonDetection.shared = nil
  }
  
  public static func getExercise() -> BaseExercise? {
    return baseExercise
  }
  
  public func getActivity() -> ExerciseViewController? {
    return baseViewController
  }
  
  public func getExerciseRenderModule() -> ExerciseRenderModule {
    return exerciseRenderModule!
  }
  
  class func getName() -> String { return "" }

  // MARK: Exercise Flow
  
  public func process(infoBlob: InfoBlob) {
    // Whenever the lead model has processed a frame. This will be called.
    let sTime = Date().getNanoseconds()
    
    _ = infoBlobArrayList.add(value: infoBlob)
    switch status {
    case .NOT_STARTED:
      break
    case .CALIBRATION:
      self.processCalibration()
    case .COUNTDOWN:
      break
    case .EXERCISE:
      self.processExerciseWhenObjectInside(infoBlob: infoBlob)
    }
    
    Profiler.get().profileTime(frameId: infoBlob.frameId!, tag: "process-exercise", delta: Date().getNanoseconds() - sTime)
    Profiler.get().profileMemory(frameId: infoBlob.frameId!)
    Profiler.get().profileTemp(frameId: infoBlob.frameId!)
  }
  
  public func processCalibration() {
    // Function called at every frame when calibrating in progress.
    calibration!.processCalibration()
    if calibration!.status == .CALIBRATED {
      status = STATUS.COUNTDOWN
      baseViewController?.startTransition(calibrated: true)
      onCalibrated()
    }
  }
  
  func processExercise(infoBlob: InfoBlob) {
    Logger.shared.logFPSEveryNSeconds(seconds: 10, msg: "\(BaseExercise.getName())", value: 1)
  }
  
  // MARK: Object In Screen?
  func nonExerciseProcessing() { 
    if objectInScreenCheckEnabled && !isObjectInScreen() {
      if !detectionsPaused {
        onOutsideScreenLogic()
      }
    } else if detectionsPaused {
      onBackInsideScreenLogic()
    }
  }
  
  // MARK: Object In Screen?
  func onOutsideScreenLogic() {
    DispatchQueue.main.async { [unowned self] in
      self.score?.stopTime()
      self.score?.resetCount()
      self.questionManager?.end()
      self.questionManager = nil
      self.detectionsPaused = true
    }
  }
  
  func onBackInsideScreenLogic() {
    DispatchQueue.main.async { [unowned self] in
      detectionsPaused = false
      score?.continueTime()
      if exerciseSettings?.usingQuestion() ?? false {
        questionManager = createQuestionManager(score: score!, questionEngine: createQuestionEngine())
        questionManager?.start()
      }
    }
  }
  
  func processExerciseWhenObjectInside(infoBlob: InfoBlob) {
    score?.setCurrentFrameId(currentFrameId: infoBlob.frameId!)
    self.processExercise(infoBlob: infoBlob)
    self.populateGraph()
  }
  
  func isObjectInScreen() -> Bool {
    var inFrame = true
    _ = self.objectDetections.map { objDet in
      inFrame = inFrame && objDet.inFrame()
    }
    if inFrame {
      inFrameLastUpdatedTime = Date().getMilliseconds()
    }
    return (Date().getMilliseconds() - inFrameLastUpdatedTime) <= OBJECTS_UNDETECTED_TIME_WINDOW
  }

  func populateGraph() {}
  
  // MARK: QuestionManager
  
  public func createAnswerEngine() -> AnswerEngine? {
    return nil
  }
  
  public func createQuestionEngine() -> QuestionEngine {
    let builder: QuestionBuilder = QuestionEngine.builder()
    switch exerciseSettings!.getQuestionMode() {
    case .COLOR:
      builder.colors(questionPath: exerciseSettings!.questionPath)
    case .PICTURE:
      builder.picture(questionPath: exerciseSettings!.questionPath)
    case .TEXT:
      builder.text(questionPath: exerciseSettings!.questionPath)
    }
    _ = builder.setAnswerCount(answerCount: exerciseSettings!.answerCount)
    _ = builder.setAnswerEngine(ansEngine: createAnswerEngine()!)
    return builder.build()!
  }
  
  public func createQuestionManager(score: BaseScore, questionEngine: QuestionEngine) -> QuestionManager {
    return QuestionManager(score: score, qEngine: questionEngine, timer: self.baseViewController!.timer!)
  }
  
  // MARK: Draw Flow
  func drawExercise(canvas: UIView) {
    canvas.setNeedsDisplay()
  }
  
  func drawExerciseDebug(canvas: UIView) {
    canvas.setNeedsDisplay()
  }
  
  func drawBoundingBox(canvas: UIView) { }
  
  // MARK: JSON Functionality
  
  public func writeToJson() {

    let eTime: Double = Date().getMilliseconds()
    let sTime: Double = self.exerciseTime ?? eTime
    let completion_time: Double = eTime - sTime
    exerciseJsonManager.fillProperties(completionTime: completion_time)
    exerciseJsonManager.convertAndWriteToFile()
  }
    
  // MARK: Native -> RN data sending functionality
  public func sendInformationBackToRN() -> [String: AnyObject]? {
    let eTime: Double = Date().getMilliseconds()
    let sTime: Double = self.exerciseTime ?? eTime
    let completion_time: Double = eTime - sTime
    var final_score: Int = 0
    var question_score: Int = 0
    let videoPath: String = ScreenRecorder.videoPath.absoluteString
    do {
      final_score = try score!.getFinalScore()
      question_score = score!.questionScore
    } catch {
      Logger.shared.logError(logType: .ERROR, error: error, extraMsg: "Score fetching error!")
    }
    

    let data: OldExerciseCompleteHelper = OldExerciseCompleteHelper(
      videoPath: videoPath,
      score: OldExerciseCompleteHelperScore(final_score: "\(final_score)",
                                         question_score: "\(question_score)"),
      json_path: exerciseJsonManager.getExerciseJsonPath().absoluteString,
      exercise_name: BaseExercise.getName(),
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

// MARK: CanDraw Functionality
extension BaseExercise: CanDraw {
  
  func draw(canvas: UIView) {
    switch status {
    case .NOT_STARTED:
      break
    case .CALIBRATION:
      calibration?.draw(canvas: canvas)
      drawBoundingBox(canvas: canvas)
    case .COUNTDOWN:
      break
    case .EXERCISE:
      drawExercise(canvas: canvas)
      questionManager?.draw(canvas: canvas)
      if score!.timeSinceLastScore > BOUNDING_BOX_TIMEOUT { self.drawBoundingBox(canvas: canvas) }
    }
  }
  
  func drawDebug(canvas: UIView) {
    switch status {
    case .NOT_STARTED:
      break
    case .CALIBRATION:
      calibration?.drawDebug(canvas: canvas)
    case .COUNTDOWN:
      break
    case .EXERCISE:
      drawExerciseDebug(canvas: canvas)
      questionManager?.drawDebug(canvas: canvas)
    }
  }
}
