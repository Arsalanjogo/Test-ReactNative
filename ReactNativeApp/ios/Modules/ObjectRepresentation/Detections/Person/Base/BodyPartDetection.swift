//
//  BodyPartDetection.swift
//  jogo
//
//  Created by arham on 14/03/2021.
//

import Foundation

class BodyPartDetection: ObjectDetection {
  // Represents the basic logic for a body part i.e. face, arm, legs
  // Provides generic functionality needed to process information and get general information.
  
  // MARK: Representation Objects
  weak internal final var person: PersonDetection? 
  internal final var bodyElements: [ObjectDetection] = [ObjectDetection]()
  internal final var bones: [Bone] = [Bone]()
  
  var associatedLabels: Set<String>?
  var objectDetectionSet: Set<ObjectDetection>?
  
  // MARK: Lifecycle
  init(label: String, modelType: ModelManager.MODELTYPE, exerciseLead: Bool, observerId: Int, person: PersonDetection) {
    self.person = person
    super.init(label: label, modelType: modelType, exerciseLead: exerciseLead, observerId: observerId)
  }
  
  public override func unsubscribe() {
    super.unsubscribe()
    bodyElements.forEach { (bdyElement) in
      bdyElement.unsubscribe()
    }
  }
  
  public override func reset() {
    super.reset()
    bodyElements.forEach { bdyElement in
      bdyElement.reset()
    }
  }
  
  // MARK: Properties Get/Set
  public func getBodyElements() -> [ObjectDetection] {
    return bodyElements
  }
  
  public override func setConfidenceScore(confidenceScore: Float) {
    super.setConfidenceScore(confidenceScore: confidenceScore)
    bodyElements.forEach { (bdyElement) in
      bdyElement.setConfidenceScore(confidenceScore: confidenceScore)
    }
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
  
  public func getObjectDetections() -> Set<ObjectDetection> {
    if objectDetectionSet == nil {
      objectDetectionSet = Set<ObjectDetection>()
      bodyElements.forEach { (bdyElement) in
        objectDetectionSet?.insert(bdyElement)
      }
    }
    return objectDetectionSet!
  }
  
  public func getName() -> String {
    return ""
  }
  override func inFrame() -> Bool {
    var val: Bool = super.inFrame()
    self.bodyElements.forEach { bdyElement in
      val = val && bdyElement.inFrame()
    }
    return val
  }
  
  // MARK: Draw functionality
  public override func drawDebug(canvas: UIView) {
    super.drawDebug(canvas: canvas)
    bones.forEach { (bone) in
      bone.drawDebug(canvas: canvas)
    }
    bodyElements.forEach { (bodyElement) in
      bodyElement.drawDebug(canvas: canvas)
    }
    
  }
  
  public override func draw(canvas: UIView) {
    super.draw(canvas: canvas)
  }
}
