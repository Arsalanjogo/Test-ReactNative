//
//  Motion.swift
//  jogo
//
//  Created by arham on 20/05/2021.
//

import CoreMotion
import Foundation

// https://developer.apple.com/documentation/coremotion/getting_processed_device-motion_data/understanding_reference_frames_and_device_attitude
class MotionSensor: BaseSensor {
  
  // Values saved over here are for calibrating.
  // Gets motion data and send to sensor Manager for further processing.
  weak var delegate: DeviceMotionProtocol?
  
  let LANDSCAPE_ROLL_MIN: Double = 70.0
  let LANDSCAPE_ROLL_MAX: Double = 105.0
  let LANDSCAPE_PITCH_MIN: Double = -4.0
  let LANDSCAPE_PITCH_MAX: Double = 4.0
  
  let PORTRAIT_PITCH_MIN: Double = 77.0
  let PORTRAIT_PITCH_MAX: Double = 90.0
  let PORTRAIT_ROLL_MAX: Double = 20.0
  let PORTRAIT_ROLL_MIN: Double = 0.0
  
  var primaryAngleDistance: Double = 0.0
  var secondaryAngleDistance: Double = 0.0
  
  override init(manager: CMMotionManager) {
    super.init(manager: manager)
    updateInterval = 0.5 / 60.0
  }
  
  public override func setUp() {
    managerRef?.deviceMotionUpdateInterval = self.updateInterval
    managerRef?.startDeviceMotionUpdates()
    timer = Timer(fire: Date(), interval: (self.updateInterval),
                  repeats: true, block: { _ in
                    // Get the gyro data.
                    if let data: CMDeviceMotion = self.managerRef?.deviceMotion {
                      self.delegate?.onReceiveMotionData(data: data)
                    }
                  })
    super.setUp()
  }
  
  public override func stop() {
    self.managerRef?.stopDeviceMotionUpdates()
    super.stop()
  }
}
