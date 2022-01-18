//
//  LocationProtocol.swift
//  Football433
//
//  Created by arham on 13/12/2021.
//

import Foundation


protocol LocationProtocol {
  func getBasicLocation() -> (x: Double, y: Double)
  func getX() -> Double
  func getY() -> Double
  func getZ() -> Double
}
