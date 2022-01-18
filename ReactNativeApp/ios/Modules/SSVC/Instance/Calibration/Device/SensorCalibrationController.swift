//
//  SensorCalibrationController.swift
//  jogo
//
//  Created by Mohsin on 20/10/2021.
//

import Foundation
import RxSwift

public class SensorCalibrationController: Controller {
  
  var sensorState: SensorCalibrationState!
  var sensorManager: SensorManager!
  
  private let disposeBag = DisposeBag()
  
  init(state: SensorCalibrationState) {
    super.init(state: state)
    sensorState = state
    sensorManager = SensorManager.createInstance()
    sensorManager.initialize(motion: true)
    bindState()
  }
  
  func isRotationCalibrated() -> Bool {
    return sensorState.isRotationCalibrated
  }
  
}

// MARK: State Binding
extension SensorCalibrationController {
  fileprivate func bindState() {
    bindRotationText()
//    bindRotationPrompt()
    bindRotationAndTiltLevel()
    bindCorrectPlacement()
  }
  
  // MARK: Rotation Text Binding
  private func bindRotationText() {
    sensorManager.motionDataObservable
      .map({ [weak self] sensorData in
        guard let strongSelf = self else { return "" }
        
        let rollAngle: Double = abs(MathUtil.radianToDegrees(value: sensorData.attitude.roll))
        let pitchAngleRaw: Double = MathUtil.radianToDegrees(value: sensorData.attitude.pitch)
        
        if rollAngle < strongSelf.sensorState.LANDSCAPE_ROLL_MIN {
          return "Tilt Up"
        } else if rollAngle > strongSelf.sensorState.LANDSCAPE_ROLL_MAX {
          return "Tilt Down"
        } else if pitchAngleRaw < strongSelf.sensorState.LANDSCAPE_PITCH_MIN {
          return "Rotate Right"
        } else if pitchAngleRaw > strongSelf.sensorState.LANDSCAPE_PITCH_MAX {
          return "Rotate Left"
        } else {
          strongSelf.sensorState.isRotationCalibrated = true
          return ""
        }
      })
      .bind(to: sensorState.rotationText)
      .disposed(by: disposeBag)
  }
  
  // MARK: Rotation Prompt Binding
  private func bindRotationPrompt() {
    sensorManager.motionDataObservable
      .map({ [weak self] sensorData in
        guard let strongSelf = self else { return (.NONE, .NONE) }
        
        let rollAngle: Double = abs(MathUtil.radianToDegrees(value: sensorData.attitude.roll))
        let pitchAngleRaw: Double = MathUtil.radianToDegrees(value: sensorData.attitude.pitch)
        
        var prompt: (RotationDirection, RotationDirection) = (.NONE, .NONE)
        
        if GameContext.getContext()?.applicationOrientation == .LANDSCAPE {
          if rollAngle < strongSelf.sensorState.LANDSCAPE_ROLL_MIN {
            prompt.0 = .UP
          } else if rollAngle > strongSelf.sensorState.LANDSCAPE_ROLL_MAX {
            prompt.0 = .DOWN
          } else {
            prompt.0 = .NONE
          }
          
          if pitchAngleRaw < strongSelf.sensorState.LANDSCAPE_PITCH_MIN {
            prompt.1 = .RIGHT
          } else if pitchAngleRaw > strongSelf.sensorState.LANDSCAPE_PITCH_MAX {
            prompt.1 = .LEFT
          } else {
            prompt.1 = .NONE
          }
        } else {
          if rollAngle < strongSelf.sensorState.PORTRAIT_ROLL_MIN {
            prompt.1 = .RIGHT
          } else if rollAngle > strongSelf.sensorState.PORTRAIT_ROLL_MAX {
            prompt.1 = .LEFT
          } else {
            prompt.1 = .NONE
          }
          
          if pitchAngleRaw < strongSelf.sensorState.PORTRAIT_PITCH_MIN {
            prompt.0 = .UP
          } else if pitchAngleRaw > strongSelf.sensorState.PORTRAIT_PITCH_MAX {
            prompt.0 = .DOWN
          } else {
            prompt.0 = .NONE
          }
        }
        return prompt
      })
      .bind(to: sensorState.rotationPrompt)
      .disposed(by: disposeBag)
  }
  
  
  // MARK: Rotation Level Binding
  private func bindRotationAndTiltLevel() {
    sensorManager.motionDataObservable
      .map({ [weak self] sensorData in
        guard let strongSelf = self else { return (0, 0) }
        
        let maxAnimFrame = strongSelf.sensorState.MAX_ANIMATION_FRAME
        
        let tiltFrame: Double = maxAnimFrame - abs((MathUtil.radianToDegrees(value: sensorData.attitude.roll) / 180) * maxAnimFrame)
        
        let pitchAngleRaw: Double = MathUtil.radianToDegrees(value: sensorData.attitude.pitch)
        let rotateFrame: Double = abs(((pitchAngleRaw / 90) * (maxAnimFrame / 2)) - (maxAnimFrame / 2))
        
        return (tiltFrame, rotateFrame)
      })
      .bind(to: sensorState.rotationAnimFrames)
      .disposed(by: disposeBag)
  }
  
  // MARK: Correct Placement Binding
  private func bindCorrectPlacement() {
    sensorManager.motionDataObservable
      .subscribe(onNext: { [weak self] sensorData in
        guard let strongSelf = self else { return }
        
        let rollAngle: Double = abs(MathUtil.radianToDegrees(value: sensorData.attitude.roll))
        let pitchAngle: Double = abs(MathUtil.radianToDegrees(value: sensorData.attitude.pitch))
        // Set state value
        if GameContext.getContext()?.applicationOrientation == .LANDSCAPE {
          strongSelf.sensorState.isRotationCalibrated = rollAngle > strongSelf.sensorState.LANDSCAPE_ROLL_MIN &&
            rollAngle < strongSelf.sensorState.LANDSCAPE_ROLL_MAX  &&
            pitchAngle < strongSelf.sensorState.LANDSCAPE_PITCH_MAX &&
            pitchAngle > strongSelf.sensorState.LANDSCAPE_PITCH_MIN
        } else {
          strongSelf.sensorState.isRotationCalibrated = pitchAngle > strongSelf.sensorState.PORTRAIT_PITCH_MIN &&
          rollAngle < strongSelf.sensorState.PORTRAIT_ROLL_MAX
        }
        
      })
      .disposed(by: disposeBag)
  }
}
