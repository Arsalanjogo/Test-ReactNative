//
//  BodyElement.swift
//  jogo
//
//  Created by Mohsin on 18/10/2021.
//

import Foundation

public class BodyElement: ObjectDetectionState {
  // Represents a single detection from the Posenet model.
  
  override init(label: String, modelType: ModelManager.MODELTYPE, exerciseLead: Bool, observerId: Int, testing: Bool = false) {
    super.init(label: label, modelType: modelType, exerciseLead: exerciseLead, observerId: observerId, testing: testing)
  }
  
  override func parse(detectedLocations: [DetectionLocation], infoBlob: InfoBlob) {
    super.parse(detectedLocations: detectedLocations, infoBlob: infoBlob)
  }
}
