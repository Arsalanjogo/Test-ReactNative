//
//  Football.swift
//  jogo
//
//  Created by arham on 05/03/2021.
//

import Foundation


class Football: TFLiteDetector {
  /// The previous football detection model. SSD. Trained on ~50k images.
  init?() {
    super.init(confidenceScore: 0.57, modelName: "footballv16")
    self.inputWidth = 300
    self.inputHeight = 300
  }
  
  public enum ObserverID: Int {
    case FOOTBALL = 1000000
    
  }
}
