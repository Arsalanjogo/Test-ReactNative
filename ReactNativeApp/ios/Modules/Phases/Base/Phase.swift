//
//  Phase.swift
//  jogo
//
//  Created by Mohsin on 13/10/2021.
//

import Foundation

public class Phase: PhaseType, CleanupProtocol {
  
  public enum State {
    case STOP
    case RESTART
    case NONE
  }
  
  
  weak var delegate: GamePhaseDelegate?
  public var nextPhase: GamePhasesEnum?
  public var prevPhase: GamePhasesEnum?
  
  
  internal var phaseName: String?
  internal var isStopRestart = false
  internal var stopRestart: SSVC<StopRestartState, StopRestartView, StopRestartController>?
  internal var timings: [String: Double] = [String: Double]()
  
  required init(delegate: GamePhaseDelegate, stopRestart: Bool) {
    self.delegate = delegate
    self.isStopRestart = stopRestart
  }
  
  public func getDebugText() -> String {
    return ""
  }
  
  public func process() {
    timings["\(#function)"] = Date().getMilliseconds()
    if let state = (stopRestart?.controller.state as? StopRestartState)?.state{
      switch state {
      case .STOP:
        self.moveToPhase(phase: .FinishPhase)
      case .RESTART:
        self.moveToPhase(phase: .CalibrationPhase)
      case .NONE:
        break
      }
    }
  }
  
  public func isDone() -> Bool {
    return false
  }
  
  public func initialize() {
    timings["\(#function)"] = Date().getMilliseconds()
    if isStopRestart {
      self.stopRestart = StopRestartBuilder.build()
    }
  }
  
  public func cleanup() {
    timings["\(#function)"] = Date().getMilliseconds()
    self.stopRestart?.cleanup()
    self.stopRestart = nil
  }
  
  public func moveToPhase(phase: GamePhasesEnum) {
    self.delegate?.changePhase(to: phase)
  }
}
