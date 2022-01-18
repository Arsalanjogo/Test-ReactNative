//
//  Location.swift
//  jogo
//
//  Created by Muhammad Nauman on 10/11/2020.
//

import Foundation

//MARK: Location Class
@objcMembers
public class Location: NSObject, CanDraw, LocationProtocol, Codable {
  
  // Location which is the parent for every point and object which has a relation to the
  // field of view.

  fileprivate var x: Double!
  fileprivate var y: Double!

  
  // MARK: Lifecycle
  init(x: Double, y: Double) {
    self.x = x
    self.y = y
    super.init()
  }
  
  //MARK: Getters
  
  public func getX() -> Double {
    return x
  }
  
  public func getY() -> Double {
    return y
  }
  
  func getXf() -> Float {
    return Float(x)
  }
  
  func getYf() -> Float {
    return Float(y)
  }
  
  func getZ() -> Double {
    return 0
  }
  
  func getZf() -> Float {
    return 0
  }
  
  func getRadius() -> Double {
    return 0.0
  }
  
  func getBasicLocation() -> (x: Double, y: Double) {
    return (x: self.x, y: self.y)
  }
  
  // MARK: Calculate Properties
  
  /// Calculate the Distance between the centers of  self and the received Location.
  /// - Parameter location: The other point Location.
  /// - Returns: Distance.
  public func getEuclideanDistance(location: Location?) -> Double {
    let diffX = (location?.getX() ?? 0) - self.getX()
    let diffY = (location?.getY() ?? 0) - self.getY()
    return hypot(diffX, diffY)
  }
  
  func checkIntersection(objectDetection: ObjectDetection) -> Bool {
    let detLoc: DetectionLocation? = objectDetection.getDetectedLocation()
    if detLoc == nil {
      return false
    }
    return checkIntersection(location: detLoc!)
  }
  
  func checkIntersection(location: Location) -> Bool {
    return max(getRadius(), location.getRadius()) > getEuclideanDistance(location: location)
  }
  
  func checkIntersection(location: Location, locRadius: Double) -> Bool {
    return max(getRadius(), locRadius) > getEuclideanDistance(location: location)
  }
  
  func checkIntersectionLenient(location: Location, multiplier: Double) -> Bool {
    return (getRadius() * multiplier) + (location.getRadius() * multiplier) > getEuclideanDistance(location: location)
  }
  
  func checkIntersectionLenient(location: Location) -> Bool {
    return checkIntersectionLenient(location: location, multiplier: 1.0)
  }
  
  // MARK: Canvas Properties
  public func canvasLocDim(canvas: UIView, loc: Double, dim: Int) -> CGFloat {
    if dim == 0 {
      return CGFloat(canvas.frame.width * CGFloat(loc))
    } else {
      return CGFloat(canvas.frame.height * CGFloat(loc))
    }
  }
  
  public func canvasX(canvas: UIView) -> CGFloat {
    return CGFloat(canvas.frame.width * CGFloat(self.getX()))
    
  }
  
  public func canvasY(canvas: UIView) -> CGFloat {
    return CGFloat(canvas.frame.height * CGFloat(self.getY()))
  }
  
  public func canvasRadius(canvas: UIView) -> CGFloat {
    return CGFloat(min(canvas.frame.width, canvas.frame.height) * CGFloat(self.getRadius()))
  }
  
  public func toString() -> String {
    return ""
  }
  
  // MARK: Drawing
  func draw(canvas: UIView) {
    
  }
  
  func drawDebug(canvas: UIView) {
    
  }
}

// MARK: Moving Location Class
public class MovingLocation: Location, MovingLocationProtocol {
  
  // MARK: Has setters
  func setX(value : Double) {
    x = value
  }

  func setY(value: Double) {
    y = value
  }
  
  func setZ(value: Double) { }
}
