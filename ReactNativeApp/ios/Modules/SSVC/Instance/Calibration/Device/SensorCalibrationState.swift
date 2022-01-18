//
//  SensorCalibrationState.swift
//  jogo
//
//  Created by Mohsin on 20/10/2021.
//

import Foundation
import RxSwift
import RxRelay

public enum RotationDirection: Int {
  case NONE = 0
  case LEFT = 1
  case RIGHT = 2
  case UP = 3
  case DOWN = 4
}

public class SensorCalibrationState: State {
  
  var rotationSensorY: Double = 0
  var rotationSensorZ: Double = 0
  
  let LANDSCAPE_ROLL_MIN: Double = 70.0
  let LANDSCAPE_ROLL_MAX: Double = 105.0
  let LANDSCAPE_PITCH_MIN: Double = -4.0
  let LANDSCAPE_PITCH_MAX: Double = 4.0
  
  let PORTRAIT_PITCH_MIN: Double = 77.0
  let PORTRAIT_PITCH_MAX: Double = 90.0
  let PORTRAIT_ROLL_MAX: Double = 20.0
  let PORTRAIT_ROLL_MIN: Double = 0.0
  
  let MAX_ANIMATION_FRAME: Double = 40
  
  let rotationText: BehaviorRelay<String> = BehaviorRelay(value: "")
  let rotationPrompt: BehaviorRelay<(RotationDirection, RotationDirection)> = BehaviorRelay(value: (.NONE, .NONE)) // (VERTICAL, HORIZONTAL)
  
  let rotationAnimFrames: BehaviorRelay<(Double, Double)> = BehaviorRelay(value: (0, 0)) // (VERTICAL, HORIZONTAL)
  
  var isRotationCalibrated: Bool = false
  var isLandscape: Bool = false
  
}
