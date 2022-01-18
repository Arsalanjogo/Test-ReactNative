//
//  BodyPartState.swift
//  jogo
//
//  Created by Mohsin on 18/10/2021.
//

import Foundation

public class BodyPartState: ObjectDetectionState {
  
  var bodyElements: [ObjectDetectionState] = []
  var bones: [BoneState] = []
  var associatedLabels: Set<String>?
  var objectDetectionSet: Set<ObjectDetectionState>?
  
  init(label: String, modelType: ModelManager.MODELTYPE, exerciseLead: Bool, observerId: Int) {
    super.init(label: label, modelType: modelType, exerciseLead: exerciseLead, observerId: observerId)
  }
  
  public func getBodyElements() -> [ObjectDetectionState] {
    return bodyElements
  }
  
  public override func setConfidenceScore(confidenceScore: Float) {
    super.setConfidenceScore(confidenceScore: confidenceScore)
    bodyElements.forEach({$0.setConfidenceScore(confidenceScore: confidenceScore)})
  }
  
  public func getAssociatedLabels() -> Set<String> {
    if associatedLabels == nil {
      associatedLabels = Set<String>()
      bodyElements.forEach { (bdyElement) in
        associatedLabels?.insert(bdyElement.label)
      }
    }
    return associatedLabels!
  }
  
  public func getObjectDetections() -> Set<ObjectDetectionState> {
    if objectDetectionSet == nil {
      objectDetectionSet = Set<ObjectDetectionState>()
      bodyElements.forEach({objectDetectionSet?.insert($0)})
    }
    return objectDetectionSet!
  }
  
  public func getName() -> String {
    return ""
  }
  
  public override func unsubscribe() {
    super.unsubscribe()
    bodyElements.forEach({$0.unsubscribe()})
  }
  
  public override func cleanup() {
    super.cleanup()
    bodyElements.forEach({$0.cleanup()})
    self.bodyElements = []
    self.bones = []
    self.associatedLabels = nil
    self.objectDetectionSet = nil
  }
}
