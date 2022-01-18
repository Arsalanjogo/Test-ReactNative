//
//  FaceState.swift
//  jogo
//
//  Created by Mohsin on 18/10/2021.
//

import Foundation

public class FaceState: BodyPartState {
  // Represents the face for the MLKit Posenet Model only.
  
  public var nose, leftEye, leftEyeInner, leftEyeOuter, rightEye, rightEyeInner, rightEyeOuter, leftEar, rightEar, leftMouth, rightMouth: BodyElement

  var noseLeftEyeInner, leftEyeInnerLeftEyeOuter, leftEyeOuterLeftEar, noseRightEyeInner, rightEyeInnerRightEyeOuter, rightEyeOuterRightEar, leftMouthRightMouth: BoneState
  
  // MARK: Lifecycle
  init(exerciseLead: Bool, modelType: ModelManager.MODELTYPE) {
    nose = BodyElement(label: Posenet.BODYPART.NOSE.rawValue, modelType: modelType, exerciseLead: exerciseLead, observerId: Posenet.ObserverID.NOSE.rawValue)
    
    leftEye = BodyElement(label: Posenet.BODYPART.LEFT_EYE.rawValue,
                          modelType: modelType, exerciseLead: exerciseLead,
                          observerId: Posenet.ObserverID.LEFT_EYE.rawValue)
    leftEyeInner = BodyElement(label: Posenet.BODYPART.LEFT_EYE_INNER.rawValue,
                               modelType: modelType, exerciseLead: exerciseLead,
                               observerId: Posenet.ObserverID.LEFT_EYE_INNER.rawValue)
    leftEyeOuter = BodyElement(label: Posenet.BODYPART.LEFT_EYE_OUTER.rawValue,
                               modelType: modelType, exerciseLead: exerciseLead,
                               observerId: Posenet.ObserverID.LEFT_EYE_OUTER.rawValue)
    leftMouth = BodyElement(label: Posenet.BODYPART.MOUTH_LEFT.rawValue,
                            modelType: modelType, exerciseLead: exerciseLead,
                            observerId: Posenet.ObserverID.MOUTH_LEFT.rawValue)
    leftEar = BodyElement(label: Posenet.BODYPART.LEFT_EAR.rawValue,
                          modelType: modelType, exerciseLead: exerciseLead,
                          observerId: Posenet.ObserverID.LEFT_EAR.rawValue)
    
    rightEye = BodyElement(label: Posenet.BODYPART.RIGHT_EYE.rawValue,
                           modelType: modelType, exerciseLead: exerciseLead,
                           observerId: Posenet.ObserverID.RIGHT_EYE.rawValue)
    rightEyeInner = BodyElement(label: Posenet.BODYPART.RIGHT_EYE_INNER.rawValue,
                                modelType: modelType, exerciseLead: exerciseLead,
                                observerId: Posenet.ObserverID.RIGHT_EYE_INNER.rawValue)
    rightEyeOuter = BodyElement(label: Posenet.BODYPART.RIGHT_EYE_OUTER.rawValue,
                                modelType: modelType, exerciseLead: exerciseLead,
                                observerId: Posenet.ObserverID.RIGHT_EYE_OUTER.rawValue)
    rightMouth = BodyElement(label: Posenet.BODYPART.MOUTH_RIGHT.rawValue,
                             modelType: modelType, exerciseLead: exerciseLead,
                             observerId: Posenet.ObserverID.MOUTH_RIGHT.rawValue)
    rightEar = BodyElement(label: Posenet.BODYPART.RIGHT_EAR.rawValue,
                           modelType: modelType, exerciseLead: exerciseLead,
                           observerId: Posenet.ObserverID.RIGHT_EAR.rawValue)
    
    noseLeftEyeInner = BoneState(bodyPart1: nose, bodyPart2: leftEyeInner)
    noseRightEyeInner = BoneState(bodyPart1: nose, bodyPart2: rightEyeInner)
    
    leftEyeInnerLeftEyeOuter = BoneState(bodyPart1: leftEyeInner, bodyPart2: leftEyeOuter)
    rightEyeInnerRightEyeOuter = BoneState(bodyPart1: rightEyeInner, bodyPart2: rightEyeOuter)
    
    leftEyeOuterLeftEar = BoneState(bodyPart1: leftEyeOuter, bodyPart2: leftEar)
    rightEyeOuterRightEar = BoneState(bodyPart1: rightEyeOuter, bodyPart2: rightEar)
    
    leftMouthRightMouth = BoneState(bodyPart1: leftMouth, bodyPart2: rightMouth)
    
    super.init(label: "FACE", modelType: modelType, exerciseLead: exerciseLead, observerId: Posenet.ObserverID.FACE.rawValue)
    self.appendToSuperParts()
  }
  
  func appendToSuperParts() {
    bodyElements.append(nose)
    bodyElements.append(leftEye)
    bodyElements.append(leftEyeInner)
    bodyElements.append(leftEyeOuter)
    bodyElements.append(leftMouth)
    bodyElements.append(leftEar)
    bodyElements.append(rightEye)
    bodyElements.append(rightEyeInner)
    bodyElements.append(rightEyeOuter)
    bodyElements.append(rightMouth)
    bodyElements.append(rightEar)
    
    bones.append(noseLeftEyeInner)
    bones.append(noseRightEyeInner)
    bones.append(leftEyeInnerLeftEyeOuter)
    bones.append(rightEyeInnerRightEyeOuter)
    bones.append(leftEyeOuterLeftEar)
    bones.append(rightEyeOuterRightEar)
    bones.append(leftMouthRightMouth)
  }
  
  // MARK: Information Flow
  public override func parse(detectedLocations: [DetectionLocation], infoBlob: InfoBlob) {
    super.parse(detectedLocations: detectedLocations, infoBlob: infoBlob)
    bones.forEach { (bone) in
      bone.updateLength()
    }
  }
  
  // MARK: Properties Get/Set
  public override func getName() -> String {
    return "face"
  }
}
