//
//  RectLocation.swift
//  jogo
//
//  Created by arham on 05/03/2021.
//

import Foundation

class RectLocation: DetectionLocation {
  
  
  // Location used for outputs from Object Detection models.
  
  private let rect: CGRect
  
  // MARK: Lifecycle
  init(rect: CGRect,
       classLabel: String,
       frameId: Int,
       confidence: Float) {
    self.rect = rect
    super.init(label: classLabel,
               centerX: Double(rect.midX),
               centerY: Double(rect.midY),
               frameId: frameId,
               confidence: confidence,
               status: STATUS.DETECTED)
  }
  
  required init(from decoder: Decoder) throws {
    fatalError("init(from:) has not been implemented")
  }
  
  public override func updateLocation(centerX: Double, centerY: Double, status: DetectionLocation.STATUS) {
    self.setX(value: centerX)
    self.setY(value: centerY)
    self.status = status
  }
  
  // MARK: Properties Get/Set
  public override func getRectangle() -> CGRect {
    return self.rect
  }
  
  override func getWidth() -> Double {
    return Double(self.rect.width)
  }
  
  override func getHeight() -> Double {
    return Double(self.rect.height)
  }
  
  override func getOrigin() -> (x: Double, y: Double) {
    return (x: Double(self.rect.origin.x), y: Double(self.rect.origin.y))
  }
  
  public func getScaledRect() -> CGRect {
    return self.rect
  }
  
  public func getRectArea() -> Double {
    return Double(self.rect.width) * Double(self.rect.height)
  }
  
  public override func getRadius() -> Double {
    // Instead of getting the smaller of the dimension, get the average dimension
    return Double((self.rect.width + self.rect.height) / 2.0)
  }
  
  // MARK: Drawing
  public override func draw(canvas: UIView) {
    
  }
  
  public override func drawDebug(canvas: UIView) {
    DrawingManager.get().drawHollowRect(view: canvas, rect: getRectangle())
  }
  
}
