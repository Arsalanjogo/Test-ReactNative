//
//  DetectionLocation.swift
//  jogo
//
//  Created by Muhammad Nauman on 10/11/2020.
//

import Foundation



public class DetectionLocation: MovingLocation, RectLocationProtocol, PointLocationProtocol, IntersectionProtocol  {
  
  internal var label: String
  public final var frameId: Int
  internal var confidence: Float
  private var processed: Bool = false
  internal var status: STATUS
  
  public enum STATUS: String {
    case DETECTED = "D"
    case INFERRED = "I"
    case MISSING = "M"
    case SKIPPED = "S"
  }
  
  // MARK: Lifecycle
  init(label: String, centerX: Double, centerY: Double, frameId: Int, confidence: Float, status: STATUS) {
    self.label = label
    self.frameId = frameId
    self.confidence = confidence
    self.status = status
    super.init(x: centerX, y: centerY)
  }
  
  required init(from decoder: Decoder) throws {
    fatalError("init(from:) has not been implemented")
  }
  
  public func updateLocation(centerX: Double, centerY: Double, status: STATUS) {
  }
  
  public func process() {
    self.processed = true
  }
  
  // MARK: Properties Get/Set
  public func getLabel() -> String {
    return self.label
  }
  
  public func getFrameId() -> Int {
    return self.frameId
  }
  
  public func getConfidence() -> Float {
    return self.confidence
  }
  
  public func getStatus() -> STATUS {
    return self.status
  }
  
  public func locationKnown() -> Bool {
    return (status == STATUS.DETECTED || status == STATUS.INFERRED)
  }
  
  public func isProcessed() -> Bool {
    return processed
  }
  
  // MARK: Calculate Properties
  public static func compareByY(firstLocation: DetectionLocation, secondLocation: DetectionLocation) -> Int {
    return (firstLocation.getY() < secondLocation.getY()) ? -1 : 1
  }
  
  public static func compareByX(firstLocation: DetectionLocation, secondLocation: DetectionLocation) -> Int {
    return (firstLocation.getX() < secondLocation.getX()) ? -1 : 1
  }
  
  // MARK: Interfaces
  
  func intersectsWith(b: IntersectionProtocol) -> Bool {
    // This is the swift specific answer for this logic.
    // return self.getRect().intersects(b.getRect())
    let rect1: CGRect = self.getRectangle()
    let otherRect: CGRect = b.getRectangle()
    let x1: Double = max(rect1.origin.x, otherRect.origin.x)
    let y1: Double = max(rect1.origin.y, otherRect.origin.y)
    let x2: Double = min(rect1.width + rect1.origin.x, otherRect.width + otherRect.origin.x)
    let y2: Double = min(rect1.height + rect1.origin.y, otherRect.height + otherRect.origin.y)
    if x2 < x1 || y2 < y1 { return false }
    return true
  }
  
  func getRectangle() -> CGRect {
    return CGRect(x: self.getX(), y: self.getY(), width: self.getWidth(), height: self.getHeight())
  }
  
  func getWidth() -> Double {
    return 0
  }
  
  func getHeight() -> Double {
    return 0
  }
  
  func getOrigin() -> (x: Double, y: Double) {
    return (x: self.getX(), y: self.getY())
  }
  
  func getCenter() -> (x: Double, y: Double) {
    return (x: self.getX(), y: self.getY())
  }
  
  func getPoint() -> CGPoint {
    return CGPoint(x: self.getX(), y: self.getY())
  }
  
  // MARK: Drawing
  override func draw(canvas: UIView) {
  }
  
  override func drawDebug(canvas: UIView) {
  }
}
