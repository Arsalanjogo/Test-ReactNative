//
//  AccelerometerSensor.swift
//  jogo
//
//  Created by arham on 20/05/2021.
//

import Foundation
import CoreMotion

class AccelerometerSensor: BaseSensor {
  // Accelerometer data extracted and sent to SensorManager.
  weak var delegate: AccelerometerDataProtocol?
  
  override init(manager: CMMotionManager) {
    super.init(manager: manager)
    updateInterval = 0.5 / 60.0
  }
  
  public override func setUp() {
    managerRef?.accelerometerUpdateInterval = self.updateInterval
    managerRef?.startAccelerometerUpdates()
    timer = Timer(fire: Date(), interval: (self.updateInterval),
                  repeats: true, block: { _ in
                    // Get the gyro data.
                    if let data: CMAccelerometerData = self.managerRef?.accelerometerData {
                      self.delegate?.onReceiveAccelerometerData(data: data)
                    }
                  })
    super.setUp()
  }
  
  public override func stop() {
    self.managerRef?.stopAccelerometerUpdates()
    super.stop()
  }
}
