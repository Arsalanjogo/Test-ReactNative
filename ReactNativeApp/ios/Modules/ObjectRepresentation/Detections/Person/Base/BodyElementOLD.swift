//
//  BodyElement.swift
//  jogo
//
//  Created by arham on 14/03/2021.
//

import Foundation

class BodyElementOLD: ObjectDetection {
  // Represents a single detection from the Posenet model.
  
  override init(label: String, modelType: ModelManager.MODELTYPE, exerciseLead: Bool, observerId: Int, testing: Bool = false) {
    super.init(label: label, modelType: modelType, exerciseLead: exerciseLead, observerId: observerId, testing: testing)
  }
  
  override func parse(detectedLocations: [DetectionLocation], infoBlob: InfoBlob) {
    super.parse(detectedLocations: detectedLocations, infoBlob: infoBlob)
  }
}
