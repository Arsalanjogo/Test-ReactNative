//
//  GameLoop.swift
//  jogo
//
//  Created by Mohsin on 12/10/2021.
//

import Foundation

final public class GameLoop {
  
  public typealias NoArgMethod = () -> Void
  
  private let timer: TimerUtil = TimerUtil(throwException: false)
  private let targets = UtilArrayList<NoArgMethod>()
  private var runner: Timer?
  
  public func start() {
    do {
      runner = try timer.scheduleInfinite(
        runnable: { [unowned self] in self.targets.get().forEach({ $0() }) },
        delay: 33,
        repeats: true
      )
    } catch {
      //TODO: Handle exception
    }
    
  }
  
  public func addTarget(method: @escaping NoArgMethod) {
    _ = self.targets.add(value: method)
  }
  
  public func stop() {
    self.targets.clear()
    runner?.invalidate()
    self.runner = nil
  }
  
}
