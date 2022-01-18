//
//  State.swift
//  jogo
//
//  Created by arham on 04/08/2021.
//

import Foundation


class StateA: CanDraw {
  
  private final var onStart: StateLogic
  private final var onEnd: StateLogic
  private final var onProcess: StateLogic
  
  private final var resolution: Resolution
  
  public final var key: String
  private final var nextStateKey: String
  
  init(val: StateCodable) throws {
    onStart = StateLogic(val: val.onStart)
    onEnd = StateLogic(val: val.onEnd)
    onProcess = StateLogic(val: val.onProcess)
    
    resolution = Resolution(val: val.resolution)
    
    key = val.key
    nextStateKey = val.nextStateKey
  }
  
  public func start() {
    onStart.execute()
  }
  
  public func process() {
    onProcess.execute()
  }
  
  public func end() {
    onEnd.execute()
  }
  
  public func checkResolution() -> Bool {
    return resolution.checkResolution()
  }
  
  public func getNextStateKey() -> String {
    return nextStateKey
  }
  
  func draw(canvas: UIView) {
    
  }
  
  func drawDebug(canvas: UIView) {
    resolution.drawDebug(canvas: canvas)
  }
  
}
