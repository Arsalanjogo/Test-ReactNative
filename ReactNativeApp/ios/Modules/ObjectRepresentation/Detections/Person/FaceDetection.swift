//
//  FaceDetection.swift
//  jogo
//
//  Created by Muhammad Nauman on 21/11/2020.
//

import Foundation

class FaceDetection: BodyPartDetection {
  // Represents the face for the MLKit Posenet Model only.
  
  public var nose, leftEye, leftEyeInner, leftEyeOuter, rightEye, rightEyeInner, rightEyeOuter, leftEar, rightEar, leftMouth, rightMouth: BodyElementOLD

  public var noseLeftEyeInner, leftEyeInnerLeftEyeOuter, leftEyeOuterLeftEar, noseRightEyeInner, rightEyeInnerRightEyeOuter, rightEyeOuterRightEar, leftMouthRightMouth: Bone
  
  // MARK: Lifecycle
  init(exerciseLead: Bool, person: PersonDetection, modelType: ModelManager.MODELTYPE) {
    nose = BodyElementOLD(label: Posenet.BODYPART.NOSE.rawValue, modelType: modelType, exerciseLead: exerciseLead, observerId: Posenet.ObserverID.NOSE.rawValue)
    
    leftEye = BodyElementOLD(label: Posenet.BODYPART.LEFT_EYE.rawValue,
                          modelType: modelType, exerciseLead: exerciseLead,
                          observerId: Posenet.ObserverID.LEFT_EYE.rawValue)
    leftEyeInner = BodyElementOLD(label: Posenet.BODYPART.LEFT_EYE_INNER.rawValue,
                               modelType: modelType, exerciseLead: exerciseLead,
                               observerId: Posenet.ObserverID.LEFT_EYE_INNER.rawValue)
    leftEyeOuter = BodyElementOLD(label: Posenet.BODYPART.LEFT_EYE_OUTER.rawValue,
                               modelType: modelType, exerciseLead: exerciseLead,
                               observerId: Posenet.ObserverID.LEFT_EYE_OUTER.rawValue)
    leftMouth = BodyElementOLD(label: Posenet.BODYPART.MOUTH_LEFT.rawValue,
                            modelType: modelType, exerciseLead: exerciseLead,
                            observerId: Posenet.ObserverID.MOUTH_LEFT.rawValue)
    leftEar = BodyElementOLD(label: Posenet.BODYPART.LEFT_EAR.rawValue,
                          modelType: modelType, exerciseLead: exerciseLead,
                          observerId: Posenet.ObserverID.LEFT_EAR.rawValue)
    
    rightEye = BodyElementOLD(label: Posenet.BODYPART.RIGHT_EYE.rawValue,
                           modelType: modelType, exerciseLead: exerciseLead,
                           observerId: Posenet.ObserverID.RIGHT_EYE.rawValue)
    rightEyeInner = BodyElementOLD(label: Posenet.BODYPART.RIGHT_EYE_INNER.rawValue,
                                modelType: modelType, exerciseLead: exerciseLead,
                                observerId: Posenet.ObserverID.RIGHT_EYE_INNER.rawValue)
    rightEyeOuter = BodyElementOLD(label: Posenet.BODYPART.RIGHT_EYE_OUTER.rawValue,
                                modelType: modelType, exerciseLead: exerciseLead,
                                observerId: Posenet.ObserverID.RIGHT_EYE_OUTER.rawValue)
    rightMouth = BodyElementOLD(label: Posenet.BODYPART.MOUTH_RIGHT.rawValue,
                             modelType: modelType, exerciseLead: exerciseLead,
                             observerId: Posenet.ObserverID.MOUTH_RIGHT.rawValue)
    rightEar = BodyElementOLD(label: Posenet.BODYPART.RIGHT_EAR.rawValue,
                           modelType: modelType, exerciseLead: exerciseLead,
                           observerId: Posenet.ObserverID.RIGHT_EAR.rawValue)
    
    noseLeftEyeInner = Bone(bodyElement1: nose, bodyElement2: leftEyeInner)
    noseRightEyeInner = Bone(bodyElement1: nose, bodyElement2: rightEyeInner)
    
    leftEyeInnerLeftEyeOuter = Bone(bodyElement1: leftEyeInner, bodyElement2: leftEyeOuter)
    rightEyeInnerRightEyeOuter = Bone(bodyElement1: rightEyeInner, bodyElement2: rightEyeOuter)
    
    leftEyeOuterLeftEar = Bone(bodyElement1: leftEyeOuter, bodyElement2: leftEar)
    rightEyeOuterRightEar = Bone(bodyElement1: rightEyeOuter, bodyElement2: rightEar)
    
    leftMouthRightMouth = Bone(bodyElement1: leftMouth, bodyElement2: rightMouth)
    
    super.init(label: "Face", modelType: modelType, exerciseLead: exerciseLead, observerId: Posenet.ObserverID.FACE.rawValue, person: person)
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
