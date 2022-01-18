//
//  TimerController.swift
//  jogo
//
//  Created by Mohsin on 27/10/2021.
//

import Foundation

public class TimerController: Controller {
  
  private var timer: Timer?
  
  init(state: TimerState) {
    super.init(state: state)
    let duration: Double = (((GameContext.getContext()?.gameDuration) ?? (TimerState.DEFAULT_GAME_TIME * 1000))/1000)
    startTimer(forSeconds: duration)
    state.startTime = Date().getMilliseconds()
    state.isTimerFinished = false
  }
  
  public func startTimer(forSeconds: Double) {
    guard let state = self.state as? TimerState else { return }
    if state.isTimerRunning { return }
    
    state.gameTime = forSeconds
    timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerTick), userInfo: nil, repeats: true)
    state.isTimerRunning = true
  }
  
  @objc func timerTick() {
    guard let state = self.state as? TimerState else { return }
    state.elapsedSeconds += 1
    if (state.gameTime - state.elapsedSeconds) == 5 {
      SpeechManager.get().talk(sentence: "Five seconds remaining.")
    }
    if state.elapsedSeconds >= state.gameTime {
      stop()
    }
  }
  
  func stop() {
    guard let state = self.state as? TimerState else { return }
    state.isTimerRunning = false
    state.elapsedSeconds = 0
    timer?.invalidate()
    timer = nil
    state.timerText.accept("00:00")
    state.isTimerFinished = true
  }
  
  func getCompletionTime() -> Double {
    guard let state = self.state as? TimerState else { return 0.0 }
    return state.elapsedSeconds
    
  }
  
  func timeFinished() -> Bool {
    guard let state = self.state as? TimerState else { return true }
    return state.isTimerFinished
  }
  
  public func process() {
    guard let state = self.state as? TimerState else { return }
    if state.isTimerRunning {
      let secs = Int((state.gameTime - state.elapsedSeconds)) % 60
      state.timerText.accept(String(format: "00:%02i", secs))
      let elapsedTime = (state.startTime + (state.gameTime * 1000)) - Date().getMilliseconds()
      state.timeProgressPercentage.accept(elapsedTime / (state.gameTime * 1000))
    }
  }
  
  public func getExerciseTime() -> Double {
    return TimerState.DEFAULT_GAME_TIME - getCompletionTime()
  }
  
  public override func getDebugText() -> String {
    guard let state = self.state as? TimerState else { return "" }
    return String(state.timeProgressPercentage.value)
  }
  
}
