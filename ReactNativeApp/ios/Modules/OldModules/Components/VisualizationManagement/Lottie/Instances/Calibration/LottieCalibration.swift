//
//  LottieCalibration.swift
//  jogo
//
//  Created by Muhammad Nauman on 27/07/2021.
//

import Foundation

class LottieCalibration{
  
  var unCalibratedAnimation: LottieRender
  var calibratingAnimation: LottieRender
  var calibratedAnimation: LottieRender
  
  var stopped = false
  
  init(calibrationAsset: LottieMapping.LottieExercise) {
    let assets = calibrationAsset.CalibrationAssets
    
    unCalibratedAnimation = LottieRender(exerciseVC: ExerciseViewController.baseViewController!, animationName: assets.outline)
    calibratingAnimation = LottieRender(exerciseVC: ExerciseViewController.baseViewController!, animationName: assets.correct)
    
    do {
      unCalibratedAnimation = try unCalibratedAnimation
        .scale(x: 0.8, y: 0.8)
        .move(x: 0.5, y: 0.5)
      
      calibratingAnimation = try calibratingAnimation
        .scale(x: 0.8, y: 0.8)
        .move(x: 0.5, y: 0.5)
    } catch let error {
      Logger.shared.logError(logType: .ERROR, error: error)
    }
    
    calibratedAnimation = LottieRender(exerciseVC: ExerciseViewController.baseViewController!, animationName: assets.calibrate)
    
    _ = try? unCalibratedAnimation.minFrame(minFrame: 10).maxFrame(maxFrame: 60).contentMode(mode: .scaleAspectFit)
    _ = try? calibratingAnimation.contentMode(mode: .scaleAspectFit)
    
    unCalibratedAnimation.lottieAnimationView.isHidden = true
    calibratingAnimation.lottieAnimationView.isHidden = true
    calibratedAnimation.lottieAnimationView.isHidden = true
  }
  
  func playUnCalibrated() {
    stopped = false
    unCalibratedAnimation.lottieAnimationView.isHidden = false
    _ = try? unCalibratedAnimation.play(loopMode: .loop)
  }
  
  func playCalibratingFirstHalf(completion: @escaping () -> Void) {
    stopped = false
    _ = try? calibratingAnimation.minFrame(minFrame: 1).maxFrame(maxFrame: 18)
    calibratingAnimation.lottieAnimationView.isHidden = false
    _ = try? calibratingAnimation.play(completion: completion)
  }
  
  func playCalibratingSecondHalf() {
    stopped = false
    _ = try? calibratingAnimation.minFrame(minFrame: 18).maxFrame(maxFrame: 35)
    calibratingAnimation.lottieAnimationView.isHidden = false
    _ = try? calibratingAnimation.play()
  }
  
  func playCalibrated(completion: @escaping () -> Void) {
    stopped = false
    calibratedAnimation.lottieAnimationView.isHidden = false
    _ = try? calibratedAnimation.play(completion: completion)
  }
  
  func isAnimationPlaying(state: CALIBRATIONSTATE) -> Bool{
    switch state {
    case .UNCALIBRATED:
      return unCalibratedAnimation.lottieAnimationView.isAnimationPlaying
    case .CALIBRATING:
      return calibratingAnimation.lottieAnimationView.isAnimationPlaying
    case .CALIBRATED:
      return calibratedAnimation.lottieAnimationView.isAnimationPlaying
    }
  }
  
  func stopAll() {
    if stopped { return }
    unCalibratedAnimation.stop()
    calibratingAnimation.stop()
    calibratedAnimation.stop()
  }
  
  func mirror() {
    unCalibratedAnimation.lottieAnimationView.flipX()
    calibratingAnimation.lottieAnimationView.flipX()
    calibratedAnimation.lottieAnimationView.flipX()
  }
  
}
