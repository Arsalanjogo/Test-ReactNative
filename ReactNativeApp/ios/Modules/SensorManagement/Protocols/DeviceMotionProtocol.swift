//
//  DeviceMotionProtocol.swift
//  jogo
//
//  Created by arham on 20/05/2021.
//

import Foundation
import CoreMotion

protocol DeviceMotionProtocol: AnyObject {
  func onReceiveMotionData(data: CMDeviceMotion)
}
