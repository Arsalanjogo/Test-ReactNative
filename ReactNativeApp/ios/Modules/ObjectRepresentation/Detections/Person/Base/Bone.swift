//
//  Bone.swift
//  jogo
//
//  Created by arham on 14/03/2021.
//

import Foundation

class Bone: CanDraw {
  // Represents the connection between 2 Body Elements.
  private final var bodyElement1: BodyElementOLD
  private final var bodyElement2: BodyElementOLD
  private var curLength: Double = 0
  private var maxLength: Double = 0
  private var boneName: String
  
  // MARK: Lifecycle
  init(bodyElement1: BodyElementOLD, bodyElement2: BodyElementOLD) {
    self.bodyElement1 = bodyElement1
    self.bodyElement2 = bodyElement2
    self.boneName = self.bodyElement1.label + "2" + self.bodyElement2.label
  }
  
  public func updateLength() {
    let l1: DetectionLocation? = self.bodyElement1.getLocation()
    let l2: DetectionLocation? = self.bodyElement2.getLocation()
    if l1 == nil || l2 == nil { return }
    if !(l1?.locationKnown() ?? false) || !(l2?.locationKnown() ?? false) { return }
    curLength = (curLength * 0.5) + (l1!.getEuclideanDistance(location: l2!) * 0.5)
    maxLength = max(curLength, maxLength)
  }
  
  // MARK: Properties Get/Set
  public func getFullLength() -> Double {
    return maxLength
  }
  
  public func getBoneName() -> String {
    return boneName
  }
  
  // MARK: Drawing
  public func drawDebug(canvas: UIView) {
    drawLine(canvas: canvas)
    
  }
  
  public func draw(canvas: UIView) {
    
  }
  
  public func drawLine(canvas: UIView) {
    let loc1: DetectionLocation? = bodyElement1.getDetectedLocation()
    let loc2: DetectionLocation? = bodyElement2.getDetectedLocation()
    if loc1 == nil || loc2 == nil { return }
    if !loc1!.locationKnown() || !loc2!.locationKnown() { return }
    
    DrawingManager.get().drawLine(view: canvas,
                                   point1: CGPoint(x: loc1!.getX(), y: loc1!.getY()),
                                   point2: CGPoint(x: loc2!.getX(), y: loc2!.getY()),
                                   color: ThemeManager.shared.theme.boneColor)
  }
}
