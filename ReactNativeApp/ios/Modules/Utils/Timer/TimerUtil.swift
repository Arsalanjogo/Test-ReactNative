//
//  TimerUtil.swift
//  jogo
//
//  Created by arham on 10/03/2021.
//

import Foundation


enum TimerUtilError: Error {
  case TimerAlreadyCancelled
}

public class TimerUtil {
  
  public typealias Runnable = () -> Void
  
  var throwException: Bool
  private var running: Bool = true
  
  init(throwException: Bool) {
    self.throwException = throwException
  }
  
  public func schedule(runnable: @escaping Runnable, delay: Double) throws -> Timer? {
    if !running {
      if throwException { throw TimerUtilError.TimerAlreadyCancelled } else { return nil }
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + (delay / 1000)) {
      runnable()
    }
    let timer: Timer? = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { _ in }
    return timer
  }
  
  public func scheduleInfinite(runnable: @escaping Runnable, delay: Double, repeats: Bool) throws -> Timer? {
    if !running {
      if throwException { throw TimerUtilError.TimerAlreadyCancelled } else { return nil }
    }
    let timer: Timer? = Timer.scheduledTimer(withTimeInterval: delay / 1000, repeats: repeats, block: { _ in
      runnable()
    })
    return timer
  }
}
