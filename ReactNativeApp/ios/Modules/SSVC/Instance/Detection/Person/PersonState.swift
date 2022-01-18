//
//  PersonState.swift
//  jogo
//
//  Created by Mohsin on 18/10/2021.
//

import Foundation

public class PersonState: ObjectDetectionState {
  
  public enum PersonDraw {
    case RECT
    case SKELETON
    case POINTS
  }
  
  public var face: FaceState?
  public var leftArm: ArmState?
  public var rightArm: ArmState?
  public var leftLeg: LegState?
  public var rightLeg: LegState?
  
  public var shoulderToShoulder: BoneState?
  public var rightShoulderRightHip: BoneState?
  public var leftShoulderLeftHip: BoneState?
  public var hipToHip: BoneState?
  public var up: Bool = true
  var isCalibrated = false
  
  private var objectDetectionSet: Set<ObjectDetectionState>?
  
  var bodyParts: [BodyPartState] = []
  var bones: [BoneState] = []
  
  
  
  init(modelType: ModelManager.MODELTYPE, exerciseLead: Bool, observerId: Int) {
    super.init(label: "Person", modelType: modelType, exerciseLead: exerciseLead, observerId: Posenet.ObserverID.PERSON.rawValue)
    
    face = FaceState(exerciseLead: exerciseLead, modelType: modelType)
    leftArm = ArmState(orientation: .LEFT, exerciseLead: exerciseLead, modelType: modelType)
    rightArm = ArmState(orientation: .RIGHT, exerciseLead: exerciseLead, modelType: modelType)
    leftLeg = LegState(orientation: .LEFT, exerciseLead: exerciseLead, modelType: modelType)
    rightLeg = LegState(orientation: .RIGHT, exerciseLead: exerciseLead, modelType: modelType)
    
    shoulderToShoulder = BoneState(bodyPart1: leftArm!.shoulder, bodyPart2: rightArm!.shoulder)
    leftShoulderLeftHip = BoneState(bodyPart1: leftArm!.shoulder, bodyPart2: leftLeg!.hip)
    rightShoulderRightHip = BoneState(bodyPart1: rightArm!.shoulder, bodyPart2: rightLeg!.hip)
    hipToHip = BoneState(bodyPart1: leftLeg!.hip, bodyPart2: rightLeg!.hip)
    
    bodyParts.append(face!)
    bodyParts.append(leftArm!)
    bodyParts.append(rightArm!)
    bodyParts.append(leftLeg!)
    bodyParts.append(rightLeg!)
    
    bones.append(shoulderToShoulder!)
    bones.append(leftShoulderLeftHip!)
    bones.append(rightShoulderRightHip!)
    bones.append(hipToHip!)
    
  }
  
  public func getDetectionSubClasses() -> Set<ObjectDetectionState> {
    if objectDetectionSet == nil {
      objectDetectionSet = Set<ObjectDetectionState>()
      bodyParts.forEach { (bdyPart) in
        let detSet: Set<ObjectDetectionState> = bdyPart.getObjectDetections()
        objectDetectionSet = objectDetectionSet?.union(detSet)
      }
    }
    return objectDetectionSet!
  }
    
  public override func setConfidenceScore(confidenceScore: Float) {
    super.setConfidenceScore(confidenceScore: confidenceScore)
    bodyParts.forEach { (bdyPart) in
      bdyPart.setConfidenceScore(confidenceScore: confidenceScore)
    }
  }
  
  public override func parse(detectedLocations: [DetectionLocation], infoBlob: InfoBlob) {
    super.parse(detectedLocations: detectedLocations, infoBlob: infoBlob)
    bones.forEach { (bone) in
      bone.updateLength()
    }
  }
  
  public override func unsubscribe() {
    super.unsubscribe()
    bodyParts.forEach { (bdyPart) in
      bdyPart.unsubscribe()
    }
  }
  
  public override func reset() {
    super.reset()
    bodyParts.forEach { bdyPart in
      bdyPart.reset()
    }
  }
  
  override public func cleanup() {
    super.cleanup()
    bodyParts.forEach { bdyPart in
      bdyPart.cleanup()
    }
  }
}
