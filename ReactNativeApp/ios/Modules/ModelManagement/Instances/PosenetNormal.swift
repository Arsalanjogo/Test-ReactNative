//
//  PosenetNormal.swift
//  jogo
//
//  Created by arham on 29/04/2021.
//

import Foundation
import MLKit

class PosenetNormal: Posenet {
  /// Overwrites the accurate version with the fast version.
  public override init() {
    super.init()
  }
  
  override func loadModel() {
    let options = PoseDetectorOptions()
    options.detectorMode = .stream
    detector = PoseDetector.poseDetector(options: options)
  }
}
