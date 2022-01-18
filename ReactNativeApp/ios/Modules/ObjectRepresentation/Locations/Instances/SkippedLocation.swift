//
//  SkippedLocation.swift
//  jogo
//
//  Created by arham on 15/06/2021.
//

import Foundation

class SkippedLocation: DetectionLocation {
  // All locations which are skipped in the processing pipeline.
  
  init(frameId: Int, label: String) {
    super.init(label: label, centerX: 0, centerY: 0, frameId: frameId, confidence: 0, status: STATUS.SKIPPED)
    process()
  }
  
  required init(from decoder: Decoder) throws {
    fatalError("init(from:) has not been implemented")
  }
  
  override func updateLocation(centerX: Double, centerY: Double, status: DetectionLocation.STATUS) {
    self.setX(value: centerX)
    self.setY(value: centerY)
    self.status = status
  }
  
  override func getRadius() -> Double {
    0
  }
  
  override func drawDebug(canvas: UIView) {
    
  }
  
  override func draw(canvas: UIView) {
    
  }
}
