//
//  ExerciseCalibrationController.swift
//  jogo
//
//  Created by Mohsin on 21/10/2021.
//

import Foundation

public class ExerciseCalibrationController: Controller {
  
  var _state: ExerciseCalibrationState!
  
  init(state: ExerciseCalibrationState) {
    super.init(state: state)
    _state = state
    let _location: [ObjectDetectionState] = GameContext.getContext()!.objectDetections
    _location.forEach { objState in
      let val = (objState as? PersonState)?.getDetectionSubClasses()
      if val != nil {
        _state.detections.append(contentsOf: val!)
      }
      let bval = (objState as? BallState)
      if bval != nil {
        _state.detections.append(bval!)
      }
    }
  }
  
  private func isInsideBox(detection: DetectionLocation) -> Bool {
    let p = _state.bottomScreen > detection.getY() &&
    _state.topScreen < detection.getY() &&
    _state.leftScreen < detection.getX() &&
    _state.rightScreen > detection.getX()
    Logger.shared.log(logType: .DEBUG, message: "Inside Box? \(p)")
    return p
  }
  
  private func checkAllPredicates(location: DetectionLocation) -> Bool {
    var allSatisfiedValue: Bool = false
    allSatisfiedValue = _state.extraChecks.allSatisfy { predicate -> Bool in
      predicate.evaluate(with: location)
    }
    return allSatisfiedValue
  }
  
  private func detectionsCalibrated() -> Bool {
    // Going through objectdetections,
    // get detectionlocation, and check with extracChecks and insideBox.
    // return if everything comes out true.
    var resultBall = false
    var resultPerson = false
    
    // For ballState.
    let balls = _state.detections
      .filter({ $0.getLabel() == BallState.LABEL })
      
    //For Person Exercise
    // FIXME: Refator
    if balls.isEmpty { resultBall = true }
    else {
      resultBall = balls
        .map({ $0.getDetectedLocation() })
        .map({ [unowned self] detection in
          detection != nil &&
          self.isInsideBox(detection: detection!) &&
          self.checkAllPredicates(location: detection!)
        })
        .allSatisfy({ $0 })
    }
    
    let person = _state.detections
      .filter({ $0.getLabel() != BallState.LABEL })
    
    
    if person.isEmpty { resultPerson = true }
    else {
      resultPerson = person
        .map({ $0.getDetectedLocation() })
        .map({ [unowned self] detection in
          detection != nil &&
          self.isInsideBox(detection: detection!) &&
          self.checkAllPredicates(location: detection!)
        })
        .allSatisfy({ $0 })
    }
    // Set state
    _state.isPersonInsideBox = resultPerson
    _state.isBallInsideBox = resultBall
    
    Logger.shared.log(logType: .DEBUG, message: "Calibration: \(resultPerson)")
    return resultBall && resultPerson
  }
  
  public func isCalibrated() -> Bool {
    // IF yes, check if time since last calibration is less than now.
    // IF yes, set status to calibrated and remove references.
    let cState: Bool = _state.calibratedSince != nil &&
    (_state.calibratedSince! + _state.CALIBRATION_TIME) < UInt(Date().getMilliseconds())
    if cState {
      _state.status = .CALIBRATED
    }
    return cState
  }
  
  public func isPersonCalibrated() -> Bool {
    return _state.isPersonInsideBox
  }
  
  public func isBallCalibrated() -> Bool {
    return _state.isBallInsideBox
  }
  
  public func process() {
    // Check if time since last calibration is less than current time.
    // IF yes, set status to calibrated and remove references.
    if !detectionsCalibrated() {
      _state.status = .UNCALIBRATED
      _state.calibratedSince = nil
    } else {
      if _state.calibratedSince == nil {
        _state.status = .CALIBRATING
        _state.calibratedSince = UInt64(Date().getMilliseconds())
      } else if _state.calibratedSince! > UInt64(Date().getMilliseconds()) {
        _state.status = .CALIBRATING
        _state.calibratedSince = UInt64(Date().getMilliseconds())
      }
    }
    //    isCalibrated()
  }
  
  public func addObjectDetection(objectDetection: ObjectDetectionState) {
    _state.detections.append(objectDetection)
  }
  
}
