//
//  PosenetAccurateSingleImage.swift
//  jogo
//
//  Created by arham on 03/06/2021.
//

import Foundation
import MLKit


class PosenetSingleImage: Posenet {
  /// Overwrites the stream mode with the singleImage mode.
  public override init() {
    super.init()
  }
  
  override func loadModel() {
    let options = AccuratePoseDetectorOptions()
    options.detectorMode = .singleImage
    detector = PoseDetector.poseDetector(options: options)
  }
}
