//
//  AccelerometerDataProtocol.swift
//  jogo
//
//  Created by arham on 20/05/2021.
//

import Foundation
import CoreMotion

protocol AccelerometerDataProtocol: AnyObject {
  func onReceiveAccelerometerData(data: CMAccelerometerData)
}
