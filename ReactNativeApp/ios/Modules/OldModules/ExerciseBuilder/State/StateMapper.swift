//
//  StateMapper.swift
//  jogo
//
//  Created by arham on 04/08/2021.
//

import Foundation

public class StateMapper: CanDraw {
  
  var states: [String: StateA] = [String: StateA]()
  private var activeState: StateA?
  
  init(value: [StateCodable]) {
    for i in 0..<value.count {
      do {
        let state: StateA = try StateA(val: value[i])
        if i == 0 {
          activeState = state
        }
        states[state.key] = state
        
      } catch {
        Logger.shared.log(logType: .ERROR, message: "Unable to load the specific state. \(value[i].key)")
      }
    }
  }
  
  func start() {
    activeState?.start()
  }
  
  func process() {
    if activeState == nil {
      return
    }
    activeState!.process()
    if !(activeState!.checkResolution())
    {
      return }
    
    activeState!.end()
    
    if !(states.keys.contains(activeState!.getNextStateKey())) {
      return
    }
    activeState = states[activeState!.getNextStateKey()]
    if (activeState == nil) {
      Logger.shared.log(logType: .ERROR, message: "Next state is NULL")
      return
    }
    activeState!.start()
    Logger.shared.log(logType: .DEBUG, message: "Next State: \(activeState?.key)")
  }
  
  func draw(canvas: UIView) {
    activeState?.draw(canvas: canvas)
    
  }
  
  func drawDebug(canvas: UIView) {
    DrawingManager.get().drawText(view: canvas, origin: nil, label: "\(activeState?.key)")
    activeState?.drawDebug(canvas: canvas)
  }
}
