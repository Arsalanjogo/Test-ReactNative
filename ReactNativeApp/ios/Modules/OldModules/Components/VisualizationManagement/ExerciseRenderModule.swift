//
//  ExerciseRenderModule.swift
//  jogo
//
//  Created by Muhammad Nauman on 20/03/2021.
//

import Foundation
import UIKit

class ExerciseRenderModule {
  
  weak final var controller: ExerciseViewController?
  weak final var exercise: BaseExercise?
  private final var exerciseRenderView: ExerciseRenderView
  private final var exerciseSettings: OldExerciseSettings
  
  private final var timerAnimation: LottieTimer
  private final var scoreAnimation: LottieCounter
//  private final var progressionAnimation: LottieProgressBar
  private final var promptAnimations: LottieMotionPrompt
  private final var lottieHiddenStop: LottieHiddenStopButton
  private final var lottieRestart: LottieRestartButton
  
  init(viewController: ExerciseViewController, exercise: BaseExercise, settings: OldExerciseSettings) {
    self.controller = viewController
    self.exercise = exercise
    self.exerciseRenderView = viewController.exerciseRenderView
    self.exerciseSettings = settings
    self.timerAnimation = LottieTimer(exerciseVC: viewController)
    self.scoreAnimation = LottieCounter(exerciseVC: viewController)
//    self.progressionAnimation = LottieProgressBar(exerciseVC: viewController)
    self.promptAnimations = LottieMotionPrompt(exerciseVC: viewController)
    self.lottieHiddenStop = LottieHiddenStopButton(exerciseVC: viewController)
    self.lottieRestart = LottieRestartButton(exerciseVC: viewController)
    self.exerciseRenderView.getStopBtn().addTarget(self, action: #selector(stopBtnAction(_:)), for: .touchUpInside)
    self.exerciseRenderView.getRestartBtn().addTarget(self, action: #selector(restartBtnAction(_:)), for: .touchUpInside)
  }
  
  @objc func stopBtnAction(_ sender: UIButton) {
    sender.removeFromSuperview()
    self.exerciseRenderView.getRestartBtn().removeFromSuperview()
    self.setProgess(value: 0)
    self.exercise?.stop()
  }
  
  @objc func restartBtnAction(_ sender: UIButton) {
    ExerciseManager.shared.restartExercise()
  }
  
  func setCount(count: Int, blink: Bool) {
    DispatchQueue.main.async {
      self.blinkScore()
    }
    exerciseRenderView.scoreView.setCount(score: "\(count)", blink: blink)
    DispatchQueue.main.async {
      if let highScore = self.exercise?.score as? HighScore{
//        self.exerciseRenderView.progressionBar.setProgress(value: Float(Double(count)/Double(highScore.highScore)))
      }
      else if let repititionScore = self.exercise?.score as? NRepititions{
//        self.exerciseRenderView.progressionBar.setProgress(value: Float(Double(count)/Double(repititionScore.repititons)))
      }
    }
  }
  
  func startNormalClock() {
    DispatchQueue.main.async {
      _ = try? self.scoreAnimation.play()
      _ = try? self.timerAnimation.play()
//      self.exerciseRenderView.scoreView.getTimer()?.setTime(time: 0, isCountDown: false)
//      self.exerciseRenderView.scoreView.getTimer()?.tick = self.blinkTime
//      self.exerciseRenderView.scoreView.getTimer()?.start()
    }
  }
  
  func resumeNormalClock() {
    DispatchQueue.main.async {
      _ = try? self.scoreAnimation.play()
      _ = try? self.timerAnimation.play()
//      self.exerciseRenderView.scoreView.getTimer()?.tick = self.blinkTime
//      self.exerciseRenderView.scoreView.getTimer()?.start(firstTime: false)
    }
  }
  
  func pauseNormalClock() {
    DispatchQueue.main.async {
//      self.exerciseRenderView.scoreView.getTimer()?.pause()
    }
  }
  
  func stopClock() {
    DispatchQueue.main.async {
//      self.exerciseRenderView.scoreView.getTimer()?.stop()
    }
  }
  
//  public func getCountUpSeconds() -> Int? {
//    return self.exerciseRenderView.scoreView?.getTimer()?.getSeconds()
//  }
  
  func startCountdownClock(time: Int, firstTime: Bool = true) {
    if firstTime {
      _ = try? scoreAnimation.play()
      _ = try? timerAnimation.play()
    }
    DispatchQueue.main.async {
//      if firstTime { self.exerciseRenderView.scoreView.getTimer()?.setTime(time: time, isCountDown: true) }
//      self.exerciseRenderView.scoreView.getTimer()?.tick = self.blinkTime
//      self.exerciseRenderView.scoreView.getTimer()?.start(firstTime: firstTime)
    }
  }
  
  func showCountdown() {
    guard let exerciseVC = controller else {
      return
    }
    LottieCountdown(exerciseVC: exerciseVC).play()
  }
  
  func startPromo() {
    guard let exerciseVC = controller else {
      return
    }
    LottieStartUp(exerciseVC: exerciseVC).play()
  }
  
  func showPrompt(promptType: LottieMotionPrompt.STATE) {
    self.promptAnimations.play(state: promptType)
  }
  
  func finish() {
    guard let exerciseVC = controller else { return }
    LottieFinish(exerciseVC: exerciseVC).play()
  }
  
  func blinkScore() {
    scoreAnimation.blink()
  }
  
  func blinkTime() {
    timerAnimation.blink()
    if let countdownScore = exercise?.score as? CountdownScore{
      countdownScore.currentTime += 1
      let value = countdownScore.currentTime/countdownScore.finalTime
//      exerciseRenderView.progressionBar.setProgress(value: Float(value))
      print(value)
    }
    else if let timerScore = exercise?.score as? TimerScore{
      timerScore.currentTime += 1
      let value = timerScore.currentTime/timerScore.finalTime
//      exerciseRenderView.progressionBar.setProgress(value: Float(value))
      print("TimerScore: \(value)")
    }
  }
  
  func setProgess(value: Float){
//    exerciseRenderView.progressionBar.setProgress(value: value)
  }
  
  func toggleGraphVisibility(hide: Bool) {
    exerciseRenderView.graphContainer.isHidden = hide
  }
  
  func hideScoreView() {
    UIView.transition(with: exerciseRenderView.scoreView, duration: 0.5, options: .transitionCrossDissolve, animations: { [unowned self] in
      self.exerciseRenderView.scoreView.isHidden = true
    })
  }
  
  func hideScore() {
    self.exerciseRenderView.scoreView.getScoreView().isHidden = true
  }
  
  func showText(string: String){
    self.exerciseRenderView.getTextLbl().text = string
  }

  func startExercise() {
    DispatchQueue.main.async {
      switch self.exerciseSettings.scoreType {
      case .COUNTDOWN:
        break
      case .HIGHSCORE:
        break
      case .NREPETITIONS:
        break
      default:
        break
      }
    }
  }
  
}
