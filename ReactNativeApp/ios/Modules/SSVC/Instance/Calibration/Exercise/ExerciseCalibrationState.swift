//
//  ExerciseCalibrationState.swift
//  jogo
//
//  Created by Mohsin on 21/10/2021.
//

import Foundation

public enum ExerciseCalibrationStatus {
  case CALIBRATING
  case CALIBRATED
  case UNCALIBRATED
}

public class ExerciseCalibrationState: State {
  
  public static let TOP_SCREEN: Double = 0.1
  public static let BOTTOM_SCREEN: Double = 0.9
  public static let LEFT_SCREEN: Double = 0.25
  public static let RIGHT_SCREEN: Double = 0.75
  public let CALIBRATION_TIME: UInt64 = 500
  
  public var status: ExerciseCalibrationStatus = .UNCALIBRATED
  
  var topScreen: Double = TOP_SCREEN
  var bottomScreen: Double = BOTTOM_SCREEN
  var leftScreen: Double = LEFT_SCREEN
  var rightScreen: Double = RIGHT_SCREEN
  
  var detections: [ObjectDetectionState] = [ObjectDetectionState]()
  var extraChecks: [(NSPredicate)] = [(NSPredicate)]()
  var calibratedSince: UInt64?
  var isPersonInsideBox: Bool = false
  var isBallInsideBox: Bool = false

}
