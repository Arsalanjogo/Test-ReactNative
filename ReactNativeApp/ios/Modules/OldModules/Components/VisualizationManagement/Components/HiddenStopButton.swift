//
//  HiddenStopButton.swift
//  jogo
//
//  Created by arham on 24/05/2021.
//

import Foundation


class HiddenStopButton: Location {
  
  public weak final var baseExercise: BaseExercise?
  
  private var pressedTime: Double = 0
  private var prevStateTime: Double?
  
  private var radius: Double = 0
  private var width: Double = 0
  private var height: Double = 0
  private var x1: Double = 0
  private var y1: Double = 0
  private var activated: Bool = false
  private let activateTime: Double = 8000
  private var activationTime: Double?
  
  init(baseExercise: BaseExercise, x: Double, y: Double, radius: Double) {
    self.baseExercise = baseExercise
    self.radius = radius
    self.width = radius * 2
    self.height = radius * 2
    self.x1 = x - radius / 2
    self.y1 = y - radius / 2
    super.init(x: x, y: y)
  }
  
  init(baseExercise: BaseExercise) {
    self.baseExercise = baseExercise
    self.radius = 0.06
    self.width = radius * 2
    self.height = radius * 2
    self.x1 = 0.86 - radius
    self.y1 = 0.86 - radius
    super.init(x: 0.86, y: 0.86)
  }
  
  required init(from decoder: Decoder) throws {
    fatalError("init(from:) has not been implemented")
  }
  
  override func getRadius() -> Double {
    return radius
  }
  
  func pressed(x: Double, y: Double) {
    if !self.activated { return }
    Logger.shared.log(logType: .DEBUG, message: "\(x), \(y)")
    if self.x1 < x && self.y1 < y  {
      DispatchQueue.main.async {
        self.baseExercise!.stop()
      }
    }
    
  }
  
}
