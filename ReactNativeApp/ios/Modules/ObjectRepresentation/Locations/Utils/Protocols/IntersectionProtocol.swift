//
//  IntersectionProtocol.swift
//  Football433
//
//  Created by arham on 13/12/2021.
//

import Foundation

/// Basically allows for the calculation of the intersection calculation for
/// any Rect - Rect intersection.
/// We can model circles and lines as Rects thus we only need the rect
/// intersection calculation logic in our location heirarchy and we would
/// be able to model all the other intersections.
protocol IntersectionProtocol {
  func getX() -> Double
  func getY() -> Double
  func getWidth() -> Double
  func getHeight() -> Double
  func getRectangle() -> CGRect
  func intersectsWith(b: IntersectionProtocol) -> Bool
}
