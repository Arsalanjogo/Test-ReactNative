//
//  Gyroscope.swift
//  jogo
//
//  Created by arham on 20/05/2021.
//

import Foundation
import CoreMotion

class Gyroscope: BaseSensor {
  // Allows gyroscope data to be connected to the sensor manager.
  weak var delegate: GyroDataFetcher?
  
  override init(manager: CMMotionManager) {
    super.init(manager: manager)
  }
  
  override func setUp() {
    managerRef?.gyroUpdateInterval = self.updateInterval
    managerRef?.startGyroUpdates()
    timer = Timer(fire: Date(), interval: (self.updateInterval),
                  repeats: true, block: { _ in
                    // Get the gyro data.
                    if let data: CMGyroData = self.managerRef?.gyroData {
                      self.delegate?.onReceiveGyroData(data: data)
                    }
                  })
    super.setUp()
  }
  
  override func stop() {
    self.managerRef?.stopGyroUpdates()
    super.stop()
  }
}
