//
//  BaseScore.swift
//  jogo
//
//  Created by arham on 10/03/2021.
//

import Foundation

class BaseScore {
  // Base score with all generic functionality needed.
  
  private var count: Int = 0
  weak internal final var baseExercise: BaseExercise?
  
  internal var running: Bool = false
  internal var countdown: Bool = false
  
  public final var countList: [(Int, Int)] = [(Int, Int)]()
  public final var scoreFrameIds: [(Int, Int)] = [(Int, Int)]()
  
  internal var currentFrameId: Int = 0
  internal var questionScore: Int = 0
  
  public var exerciseRenderModule: ExerciseRenderModule?
  var decrementSound: SoundRender
  var resetSound: SoundRender
  var incrementSound: SoundRender
  var lastScoreTime: Date
  var timeSinceLastScore: Double {
    return Date().timeIntervalSince(lastScoreTime)
  }
  
  // MARK: Lifecycle
  init(exercise: BaseExercise) {
    self.baseExercise = exercise
    self.exerciseRenderModule = exercise.getExerciseRenderModule()
    decrementSound = SoundRender(value: SoundMapping.Error.Error.Asset)
    resetSound = SoundRender(value: SoundMapping.Error.ConeError.Asset)
    incrementSound = SoundRender(value: SoundMapping.Score.Count.Asset)
    lastScoreTime = Date()
  }
  
  public func resetScore() {
    self.count = 0
    self.stop()
    self.stopTime()
    self.questionScore = 0
    self.currentFrameId = 0
    self.countList = [(Int, Int)]()
    self.scoreFrameIds = [(Int, Int)]()
  }
  
  public func stop() {
    running = false
  }
  
  // MARK: Start Score
  public func start() {
    running = true
    lastScoreTime = Date()
  }
  
  func startNormalTime() {
    exerciseRenderModule?.startNormalClock()
  }
  
  func startCountdownTime(time: Int, firstTime: Bool = true) {
    exerciseRenderModule?.startCountdownClock(time: time, firstTime: firstTime)
  }
  
  // MARK: Score Logic
  internal func setCount(count: Int, blink: Bool) {
    if !running { return }
    self.count = count
    lastScoreTime = Date()
    exerciseRenderModule?.setCount(count: count, blink: blink)
    self.countList.append((currentFrameId, count))
    self.scoreFrameIds.append((currentFrameId, count))
    ExerciseStatsJsonManager.get().setScoreIds(value: ScoreJson(frame_id: currentFrameId, score: count))
  }
  
  public func getCount() -> Int {
    return self.count
  }
  
  public func incrementCount() {
    self.incrementCount(amount: 1, blink: true, beep: true)
  }
  
  public func incrementCount(amount: Int, blink: Bool, beep: Bool) {
    if !running { return }
    if beep {
      _ = self.incrementSound.play()
    }
    self.setCount(count: count + amount, blink: blink)
  }
  
  public func decrementCount() {
    self.decrementCount(amount: 1, blink: true, beep: true)
  }
  
  public func decrementCount(amount: Int, blink: Bool, beep: Bool) {
    if !running { return }
    if beep {
      _ = self.decrementSound.play()
    }
    setCount(count: max(count - amount, 0), blink: blink)
  }
  
  public func resetCount() {
    self.resetCount(blink: true, beep: true)
  }
  
  public func resetCount(blink: Bool, beep: Bool) {
    for idx in 0..<scoreFrameIds.count {
      let val: (Int, Int) = scoreFrameIds[idx]
      if val.0 == currentFrameId {
        return
      }
    }
    scoreFrameIds.append((currentFrameId, 0))
    if !running { return }
    if beep { _ = self.decrementSound.play() }
    setCount(count: 0, blink: blink)
  }
  
  public func reset() {
    if !running { return }
    self.resetCount()
  }
  
  // MARK: Time Logic
//  private func getTime() -> Int {
//      return exerciseRenderModule?.getCountUpSeconds() ?? 0
//  }
  
  public func continueTime() {
    if countdown {
//      startCountdownTime(time: self.getTime(), firstTime: false)
    } else {
      startNormalTime()
    }
  }
  
  public func resumeTime() {
    exerciseRenderModule?.resumeNormalClock()
  }
    
  public func stopTime() {
    exerciseRenderModule?.stopClock()
  }
  
  public func pauseTime() {
      exerciseRenderModule?.pauseNormalClock()
  }
  
  // MARK: Properties Get/Set
    
  public func getFinalScore() throws -> Int {
    if running {
      throw RuntimeError("score should not be running")
    }
    return count
  }
  
  public func setCurrentFrameId(currentFrameId: Int) {
    self.currentFrameId = currentFrameId
  }
  
  // MARK: Stop Exercise.
  public func stopExercise() {
    baseExercise?.stop()
  }
  
  // MARK: Question Logic
  public func addCorrectAnswer() {
    self.questionScore += 1
    _ = self.incrementSound.play()
  }
  
  public func addWrongAnswer() {
    _ = self.decrementSound.play()
  }
  
  public func addSkippedAnswer() {
    _ = self.decrementSound.play()
  }
  
  public func getQuestionScore() -> Int {
    return self.questionScore
  }
}

struct RuntimeError: Error {
    let message: String

    init(_ message: String) { self.message = message }

    public var localizedDescription: String { return message }
}
