//
//  PhaseManager.swift
//  jogo
//
//  Created by Mohsin on 14/10/2021.
//

import Foundation
import UIKit

public class PhaseManager: GamePhaseDelegate, ContextPhaseDelegate {
  
//  public static var timer: TimerUtil?
  public var currentPhase: PhaseType?
  
  private var gameLoop: GameLoop!
  weak private var endGameDelegate: GameEndDelegate?
  
  var phases: [Phase] = []
  
  init(gameEndDelegate: GameEndDelegate) {
    let time: Double = Date().getMilliseconds()
    self.endGameDelegate = gameEndDelegate
    setupEnvironment()
    setupPhases()
    Profiler.get().profileTime(frameId: GameContext.getContext()?.currentFrameNumber ?? -1, tag: "PhaseManager-\(#function)", delta: Date().getMilliseconds() - time)
  }
  
  func setupEnvironment() {
//    PhaseManager.timer = TimerUtil(throwException: false)
    gameLoop = GameLoop()
    gameLoop.addTarget(method: self.process)
    // TODO: Add condition to run this only in debug mode
    gameLoop.addTarget(method: self.debugLog)
  }
  
  public func setupPhases() {
    phases.append(ContextInitPhase(delegate: self, exercisePhaseMod: self))
    phases.append(VideoPhase(delegate: self, stopRestart: false))
    phases.append(PromoPhase(delegate: self, stopRestart: false))
    phases.append(CalibrationPhase(delegate: self, stopRestart: true))
    phases.append(CountdownPhase(delegate: self, stopRestart: false))
    phases.append(EndOfExercisePhase(delegate: self, stopRestart: false))
    phases.append(FinishPhase(delegate: self, stopRestart: false))
    phases.append(CleanupPhase(delegate: self, stopRestart: false))
  }
  
  public func start() {
    currentPhase = phases[0]
    currentPhase!.initialize()
    gameLoop.start()
  }
  
  public func process() {
    currentPhase!.process()
    if currentPhase!.isDone() {
      // TODO: Convert this to use the CleanupPhaseDelegate for proper access control of this functionality.
      if currentPhase!.nextPhase == nil {
        // Close game
        dismissGame()
      } else {
        // Proceed to other phase
        currentPhase!.moveToPhase(phase: currentPhase!.nextPhase!)
      }
    }
  }
  
  public func stop() {
    self.currentPhase = nil
    self.phases.removeAll()
    gameLoop.stop()
  }
  
  
  public func debugLog() {
    print(currentPhase?.getDebugText() ?? "")
  }
    
  // MARK: GamePhaseDelegate
  func changePhase(to phase: GamePhasesEnum) {
    if currentPhase != nil {
      currentPhase?.cleanup()
    }
    currentPhase = phases[phase.rawValue]
    currentPhase!.initialize()
  }
  
  func removeGamePhase() {
    if phases.isEmpty { return }
    let gamePhaseIndex: Int = GamePhasesEnum.GamePhase.rawValue
    if phases.count <= gamePhaseIndex { return }
    let gamePhase = phases[gamePhaseIndex]
    gamePhase.cleanup()
    phases.remove(at: gamePhaseIndex)
  }
  
  func insertGamePhase(value: GamePhasesName?) {
    guard let gamePhaseName = value else { return }
    guard let val = GameSelector.select(name: gamePhaseName) else { return }
    if self.phases.count < GamePhasesEnum.GamePhase.rawValue {
      Logger.shared.logError(text: "The phases prior to GamePhases are not populated yet!!!, Please try again after populating them.")
    }
    self.phases.insert(val.init(delegate: self, stopRestart: true), at: GamePhasesEnum.GamePhase.rawValue)
  }
  
  private func dismissGame() {
    DispatchQueue.main.async { [weak self] in
      self?.stop()
      self?.endGameDelegate?.dismissGame()
    }
  }
  
}

public enum GamePhasesEnum: Int {
  case ContextInitPhase = 0
  case VideoPhase = 1
  case PromoPhase = 2
  case CalibrationPhase = 3
  case CountDownPhase = 4
  case GamePhase = 5
  case EndOfExercisePhase = 6
//  case FailurePhase = 7
  case FinishPhase = 7
  case CleanupPhase = 8
}
