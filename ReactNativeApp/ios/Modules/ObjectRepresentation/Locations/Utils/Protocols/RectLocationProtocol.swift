//
//  RectLocationProtocol.swift
//  Football433
//
//  Created by arham on 13/12/2021.
//

import Foundation

protocol RectLocationProtocol {
  func getRectangle() -> CGRect
  func getWidth() -> Double
  func getHeight() -> Double
  func getOrigin() -> (x: Double, y: Double)
}
