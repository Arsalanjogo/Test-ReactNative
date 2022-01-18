//
//  TimerState.swift
//  jogo
//
//  Created by Mohsin on 27/10/2021.
//

import Foundation
import RxRelay
import RxSwift

public class TimerState: State {
  
  public var timer: Timer?
  public var isTimerRunning = false
  public var gameTime: Double = 0 // seconds
//  public var timerText = "00:00"
//  public var timeProgressPercentage: Double = 100
  public let timerText: BehaviorRelay<String> = BehaviorRelay(value: "00:00")
  public let timeProgressPercentage: BehaviorRelay<Double> = BehaviorRelay(value: 1.0)
  public var progressBarLength: Double = 0
  public var startTime: Double = 0
  public var isTimerFinished: Bool = false
  
  public var elapsedSeconds: Double = 0
  public static let DEFAULT_GAME_TIME: Double = 10
  
  public override func getDebugText() -> String {
    return "elapsedSeconds: \(elapsedSeconds)"
  }

}
