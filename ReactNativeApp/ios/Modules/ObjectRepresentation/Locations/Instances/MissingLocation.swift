//
//  MissingLocation.swift
//  jogo
//
//  Created by arham on 05/03/2021.
//

import Foundation

class MissingLocation: DetectionLocation {
  // All Locations which are missing the frame flow.
  
  // MARK: Lifecycle
  init(classLabel: String, frameId: Int) {
    super.init(label: classLabel, centerX: 0.0, centerY: 0.0, frameId: frameId, confidence: 0.0, status: STATUS.MISSING)
    process()
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
  
  public override func getRadius() -> Double {
    return 0.0
  }
  
  // MARK: Drawing functionality
  
  public override func draw(canvas: UIView) {
    
  }
  
  public override func drawDebug(canvas: UIView) {
    
  }
}
