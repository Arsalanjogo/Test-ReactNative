//
//  LottieCalibrationPrompts.swift
//  jogo
//
//  Created by arham on 03/08/2021.
//

import Foundation

class LottieCalibrationPrompts {
  
  enum STATE {
    case UP
    case DOWN
    case LEFT
    case RIGHT
    case ALL
    case VERTICAL
    case HORIZONTAL
  }
  
  internal var tiltUp: LottieRender?
  internal var tiltDown: LottieRender?
  internal var tiltLeft: LottieRender?
  internal var tiltRight: LottieRender?
  
  init() {
    // Up
    tiltUp = try? LottieRender(exerciseVC: ExerciseViewController.baseViewController!, animationName: LottieMapping.RotationPrompt.UP.rawValue)
      .onStop { [weak self] in
        self?.tiltUp?.lottieAnimationView.isHidden = true
      }
      .onStart { [weak self] in
        self?.tiltUp?.lottieAnimationView.isHidden = false
      }
      .scale(x: 0.4, y: 0.5)
      .move(x: 0.5, y: 0.25)
    tiltUp?.lottieAnimationView.isHidden = true
    
    // Down
    tiltDown = try? LottieRender(exerciseVC: ExerciseViewController.baseViewController!, animationName: LottieMapping.RotationPrompt.DOWN.rawValue)
      .onStop { [weak self] in
        self?.tiltDown?.lottieAnimationView.isHidden = true
      }
      .onStart { [weak self] in
        self?.tiltDown?.lottieAnimationView.isHidden = false
      }
      .scale(x: 0.4, y: 0.5)
      .move(x: 0.5, y: 0.75)
    tiltDown?.lottieAnimationView.isHidden = true
    // Left
    tiltLeft = try? LottieRender(exerciseVC: ExerciseViewController.baseViewController!, animationName: LottieMapping.RotationPrompt.LEFT.rawValue)
      .onStop { [weak self] in
        self?.tiltLeft?.lottieAnimationView.isHidden = true
      }
      .onStart { [weak self] in
        self?.tiltLeft?.lottieAnimationView.isHidden = false
      }
      .scale(x: 0.4, y: 0.5)
      .move(x: 0.2, y: 0.5)
    tiltLeft?.lottieAnimationView.isHidden = true
    // Right
    tiltRight = try? LottieRender(exerciseVC: ExerciseViewController.baseViewController!, animationName: LottieMapping.RotationPrompt.RIGHT.rawValue)
      .onStop { [weak self] in
        self?.tiltRight?.lottieAnimationView.isHidden = true
      }
      .onStart { [weak self] in
        self?.tiltRight?.lottieAnimationView.isHidden = false
      }
      .scale(x: 0.4, y: 0.5)
      .move(x: 0.8, y: 0.5)
    tiltRight?.lottieAnimationView.isHidden = true
  }
  
  func play(state: STATE) {
    switch state {
    case .UP:
      _ = try? self.tiltUp?.play(loopMode: .loop, completion: nil)
    case .DOWN:
      _ = try? self.tiltDown?.play(loopMode: .loop, completion: nil)
    case .LEFT:
      _ = try? self.tiltLeft?.play(loopMode: .loop, completion: nil)
    case .RIGHT:
      _ = try? self.tiltRight?.play(loopMode: .loop, completion: nil)
    case .HORIZONTAL:
      break
    case .VERTICAL:
      break
    case .ALL:
      break
    }
  }
  
  func stop(state: STATE) {
    switch state {
    case .UP:
      tiltUp?.stop()
    case .DOWN:
      tiltDown?.stop()
    case .LEFT:
      tiltLeft?.stop()
    case .RIGHT:
      tiltRight?.stop()
    case .VERTICAL:
      tiltUp?.stop()
      tiltDown?.stop()
    case .HORIZONTAL:
      tiltLeft?.stop()
      tiltRight?.stop()
    case .ALL:
      tiltUp?.stop()
      tiltDown?.stop()
      tiltLeft?.stop()
      tiltRight?.stop()
    }
  }
}
