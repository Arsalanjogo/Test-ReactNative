//
//  PointLocationProtocol.swift
//  Football433
//
//  Created by arham on 13/12/2021.
//

import Foundation

protocol PointLocationProtocol {
  func getCenter() -> (x: Double, y: Double)
  func getRadius() -> Double
  func getPoint() -> CGPoint
  
}
