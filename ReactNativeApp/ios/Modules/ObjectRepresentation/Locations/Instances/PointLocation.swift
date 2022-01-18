//
//  PointLocation.swift
//  jogo
//
//  Created by arham on 05/03/2021.
//

import Foundation

class PointLocation: DetectionLocation {
  
  // Used for landmarks or points detected. Points are represented by x,y,z?.
  
  private var radius: Double
  private var z: Double
  
  // MARK: Lifecycle
  init(classLabel: String,
       centerX: Double,
       centerY: Double,
       frameId: Int,
       confidence: Float,
       status: STATUS,
       radius: Double,
       zValue: Double = 0) {
    self.radius = radius
    self.z = zValue
    super.init(label: classLabel, centerX: centerX, centerY: centerY,
               frameId: frameId, confidence: confidence, status: status)
  }
  
  init(classLabel: String,
       centerX: Double,
       centerY: Double,
       frameId: Int,
       confidence: Float,
       zValue: Double = 0) {
    self.radius = 0.01
    self.z = zValue
    super.init(label: classLabel, centerX: centerX, centerY: centerY, frameId: frameId,
               confidence: confidence, status: STATUS.DETECTED)
  }
  
  required init(from decoder: Decoder) throws {
    fatalError("init(from:) has not been implemented")
  }
  
  public override func updateLocation(centerX: Double,
                                      centerY: Double,
                                      status: DetectionLocation.STATUS) {
    self.setX(value: centerX)
    self.setY(value: centerY)
    self.status = status
  }
  
  // MARK: Properties Get/Set
  public override func getRadius() -> Double {
    return self.radius
  }
  
  public func getZValue() -> Double {
    return self.z
  }
  
  public func setRadius(value: Double) {
    self.radius = value
  }
  
  override func getCenter() -> (x: Double, y: Double) {
    return (x: self.getX(), y: self.getY())
  }
  
  override func getPoint() -> CGPoint {
    return CGPoint(x: self.getX(), y: self.getY())
  }
  
  // MARK: Drawing
  
  public override func draw(canvas: UIView) {
    
  }
  
  public override func drawDebug(canvas: UIView) {
    
  }
}
