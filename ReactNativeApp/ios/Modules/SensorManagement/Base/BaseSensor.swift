//
//  BaseSensor.swift
//  jogo
//
//  Created by arham on 21/05/2021.
//

import Foundation
import CoreMotion

class BaseSensor {
  // Create the basic functionality for the all sensors.
  // Allows connection for timer connected fetching of sensor data.
  
  internal var updateInterval = 1.0 / 60.0  // Every second.
  internal weak var managerRef: CMMotionManager?
  internal var timer: Timer?
  
  init(manager: CMMotionManager) {
    managerRef = manager
  }
  
  public func setUp() {
    if timer == nil {
      return
    }
    RunLoop.current.add(self.timer!, forMode: .default)
  }
  
  public func stop() {
    if self.timer != nil {
      self.timer?.invalidate()
      self.timer = nil
    }
    self.managerRef = nil
  }
  
}
