//
//  Calibration.swift
//  jogo
//
//  Created by Muhammad Nauman on 07/11/2020.
//

import Foundation
import RxSwift

public enum CALIBRATIONSTATE {
  case CALIBRATING
  case CALIBRATED
  case UNCALIBRATED
}

class Calibration {
  // Used to detect if the appropriate conditions are met before the exercise
  // could be started.
  // Mainly used to detect if the person is within the specific bounds of the view.
  // Additional constraints can be applied via predicates. Implementation of such can be seen in the BaseExercises.
  
  // MARK: Variables
  public var status: CALIBRATIONSTATE = .UNCALIBRATED
  public var exerciseStoppedViaButton = false
  
  internal var CALIBRATIONTIME: UInt64 = 500
  internal var calibratedSince: UInt64?
  
  public static let TOP_SCREEN: Double = 0.1
  public static let BOTTOM_SCREEN: Double = 0.9
  public static let LEFT_SCREEN: Double = 0.1
  public static let RIGHT_SCREEN: Double = 0.9
  public static let TOLERANCE: Double = 0.02
  
  internal var topScreen: Double = TOP_SCREEN
  internal var bottomScreen: Double = BOTTOM_SCREEN
  internal var leftScreen: Double = LEFT_SCREEN
  internal var rightScreen: Double = RIGHT_SCREEN
  
  internal var calibrationImage: UIImage?
  internal var keepBitmapAspectRatio: Bool = true
  
  internal var screenMessage: String = "Move into the lines"
  internal var xScreenMessage: Double = 0.0
  internal var yScreenMessage: Double = 0.0
  internal var textSize: Int = 100
  
  internal var detections: [ObjectDetection] = [ObjectDetection]()
  internal var extraChecks: [(NSPredicate)] = [(NSPredicate)]()
  
  // MARK: Weak References
  weak internal var baseExercise: BaseExercise?
  private weak var sensorManager: SensorManager?
  var lottieCalibration: LottieCalibration?
  var lottieCalibrationPrompts: LottieCalibrationPrompts?
  
  // MARK: Lifecycle
  init(calibrationImage: UIImage) {
    self.calibrationImage = calibrationImage
    self.commonInits()
  }
  
  init(calibrationImage: UIImage,
       topScreen: Double,
       bottomScreen: Double,
       leftScreen: Double,
       rightScreen: Double) {
    self.calibrationImage = calibrationImage
    self.topScreen = topScreen - Calibration.TOLERANCE
    self.bottomScreen = bottomScreen + Calibration.TOLERANCE
    self.leftScreen = leftScreen - Calibration.TOLERANCE
    self.rightScreen = rightScreen + Calibration.TOLERANCE
    self.commonInits()
  }
  
  init(calibrationAsset: LottieMapping.LottieExercise) {
    lottieCalibration = LottieCalibration(calibrationAsset: calibrationAsset)
    self.commonInits()
  }
  
  func commonInits() {
    initDirectionLottie()
    self.sensorManager = SensorManager.createInstance()
    self.sensorManager!.initialize(motion: true)
  }
  
  private func initDirectionLottie() {
    lottieCalibrationPrompts = LottieCalibrationPrompts()
  }
  
  public func setFrameSize(topScreen: Double = TOP_SCREEN,
                           bottomScreen: Double = BOTTOM_SCREEN,
                           leftScreen: Double = LEFT_SCREEN,
                           rightScreen: Double = RIGHT_SCREEN) {
    self.topScreen = topScreen
    self.bottomScreen = bottomScreen
    self.leftScreen = leftScreen
    self.rightScreen = rightScreen
  }
  
  func setBaseExercise(baseExercise: BaseExercise) {
    self.baseExercise = baseExercise
  }
  
  func reset() {
    self.calibratedSince = nil
    self.status = .UNCALIBRATED
  }
  
  // MARK: Predicate Logic.
  func addExtraCheck(predicate: NSPredicate) {
    self.extraChecks.append(predicate)
  }
  
  private func checkAllPredicates(location: DetectionLocation) -> Bool {
    var allSatisfiedValue: Bool = false
    allSatisfiedValue = self.extraChecks.allSatisfy { predicate -> Bool in
      predicate.evaluate(with: location)
    }
    return allSatisfiedValue
  }
  
  func isInsideBox(detection: DetectionLocation) -> Bool {
    let isInside: Bool = bottomScreen > detection.getY() &&
      topScreen < detection.getY() &&
      leftScreen < detection.getX() &&
      rightScreen > detection.getX()
    return isInside
  }
  
  public func detectionsCalibrated() -> Bool {
    // Going through objectdetections,
    // get detectionlocation, and check with extracChecks and insideBox.
    // return if everything comes out true.
    
    let result: Bool = detections.map({ $0.getDetectedLocation() })
      .map({
        $0 != nil &&
          isInsideBox(detection: $0!) &&
          checkAllPredicates(location: $0!)
      })
      .allSatisfy({ $0 })
    if !result { SpeechManager.get().talk(sentence: "Get inside the lines") }
    return result
  }
  
  public func processCalibration() {
    // Check if device is placed correctly and all detections are within the bounds.
    // and if the time of last calibration is older than now.
    // If yes, check if time since last calibration is less than to now.
    // IF yes, set self to calibrated and remove references.
    if sensorManager === nil {
      sensorManager = SensorManager.createInstance()
    }
    if !detectionsCalibrated() || !sensorManager!.isPlacedCorrectly() {
      self.status = .UNCALIBRATED
      calibratedSince = nil
    } else {
      if calibratedSince == nil {
        self.status = .CALIBRATING
        calibratedSince = UInt64(Date().getMilliseconds())
      } else if calibratedSince! > UInt64(Date().getMilliseconds()) {
        self.status = .CALIBRATING
        calibratedSince = UInt64(Date().getMilliseconds())
      }
    }
    isCalibrated()
  }
  
  public func isCalibrated() {
    // If yes, check if time since last calibration is less than to now.
    // IF yes, set self to calibrated and remove references.
    let cState: Bool = calibratedSince != nil &&
      (calibratedSince! + CALIBRATIONTIME) < UInt(Date().getMilliseconds())
    if cState {
      self.status = .CALIBRATED
      self.sensorManager = nil
    }
  }
  
  func removeSensorManager() {
    self.sensorManager = nil
  }
  
  public func addObjectDetection(objectDetection: ObjectDetection) {
    detections.append(objectDetection)
  }
  
  // MARK: Drawing logic.
  public func drawCalibratedImage(canvas: UIView) {
    guard lottieCalibration == nil else { return }
  }
  
  public func stopViaButton() {
    self.exerciseStoppedViaButton = true
    self.lottieCalibration?.stopAll()
    self.lottieCalibrationPrompts?.stop(state: .ALL)
  }
  
  public func drawSensor(canvas: UIView) -> Bool {
    let correctlyPlaced: Bool = sensorManager?.isPlacedCorrectly() ?? false
    
    if correctlyPlaced {
      baseExercise?.getExerciseRenderModule().showText(string: self.screenMessage)
      lottieCalibrationPrompts?.stop(state: .ALL)
    } else {
      baseExercise?.getExerciseRenderModule().showText(string: "")
      
      // MARK: - Rotation Prompts
      let cameraFacing = baseExercise!.getActivity()!.getCameraFacing()
      
      // Vertical
      
      // TODO: Make enum for sensorManager and lottieCalibration same to remove switch case.
      // Look into this.
      
      switch cameraFacing {
      case .BACK:
        if sensorManager?.rotationPromptVertical == .DOWN {
          lottieCalibrationPrompts?.play(state: .DOWN)
        } else if sensorManager?.rotationPromptVertical == .UP {
          lottieCalibrationPrompts?.play(state: .UP)
        } else {
          lottieCalibrationPrompts?.stop(state: .VERTICAL)
        }
      case .FRONT:
        // Invert
        if sensorManager?.rotationPromptVertical == .DOWN {
          lottieCalibrationPrompts?.play(state: .UP)
        } else if sensorManager?.rotationPromptVertical == .UP {
          lottieCalibrationPrompts?.play(state: .DOWN)
        } else {
          lottieCalibrationPrompts?.stop(state: .VERTICAL)
        }
      default:
        break
      }
      
      // Horizontal
      switch sensorManager?.rotationPromptHorizontal {
      case .LEFT:
        lottieCalibrationPrompts?.play(state: .LEFT)
      case .RIGHT:
        lottieCalibrationPrompts?.play(state: .RIGHT)
      default:
        lottieCalibrationPrompts?.stop(state: .HORIZONTAL)
      }
    }
    canvas.backgroundColor = sensorManager?.angleColor
    sensorManager?.draw(canvas: canvas)
    return correctlyPlaced
  }
}

extension Calibration: CanDraw {
  
  @objc func draw(canvas: UIView) {
    if self.exerciseStoppedViaButton { return }
    
    let correctlyPlaced = self.drawSensor(canvas: canvas)
    if correctlyPlaced {
      lottieCalibration?.playUnCalibrated()
    } else {
      lottieCalibration?.stopAll()
    }
    drawCalibratedImage(canvas: canvas)
  }
  
  @objc func drawDebug(canvas: UIView) {
    for detection in detections {
      detection.drawDebug(canvas: canvas)
    }
  }
  
}
