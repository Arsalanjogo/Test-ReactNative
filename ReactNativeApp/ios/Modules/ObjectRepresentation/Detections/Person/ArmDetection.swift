//
//  ArmDetection.swift
//  jogo
//
//  Created by Muhammad Nauman on 21/11/2020.
//

import Foundation

class ArmDetection: BodyPartDetection {
  // Represents the arm for the MLKit Posenet Model only.
  
  public enum Orientation: String {
    case LEFT = "Left"
    case RIGHT = "Right"
  }
  
  public final let EXTENSION_THRESHOLD: Double = 0.90
  public final let scalar: Double = 10.0
  
  var orientation: Orientation
  
  public final var shoulder: BodyElementOLD
  public final var elbow: BodyElementOLD
  public final var wrist: BodyElementOLD
  
  public final var pinky: BodyElementOLD
  public final var index: BodyElementOLD
  public final var thumb: BodyElementOLD
  
  public final var underArm: Bone
  public final var upperArm: Bone
  
  // MARK: Lifecycle
  init(orientation: Orientation, exerciseLead: Bool, person: PersonDetection, modelType: ModelManager.MODELTYPE) {
    self.orientation = orientation
    var observerId: Int
    switch orientation {
    case .LEFT:
      observerId = Posenet.ObserverID.LEFT_ARM.rawValue
      self.shoulder = BodyElementOLD(label: Posenet.BODYPART.LEFT_SHOULDER.rawValue,
                                  modelType: modelType, exerciseLead: exerciseLead, observerId: Posenet.ObserverID.LEFT_SHOULDER.rawValue)
      self.elbow = BodyElementOLD(label: Posenet.BODYPART.LEFT_ELBOW.rawValue,
                               modelType: modelType, exerciseLead: exerciseLead, observerId: Posenet.ObserverID.LEFT_SHOULDER.rawValue)
      self.wrist = BodyElementOLD(label: Posenet.BODYPART.LEFT_WRIST.rawValue,
                               modelType: modelType, exerciseLead: exerciseLead, observerId: Posenet.ObserverID.LEFT_WRIST.rawValue)
      self.pinky = BodyElementOLD(label: Posenet.BODYPART.LEFT_PINKY_FINGER.rawValue,
                               modelType: modelType, exerciseLead: exerciseLead, observerId: Posenet.ObserverID.LEFT_PINKY_FINGER.rawValue)
      self.index = BodyElementOLD(label: Posenet.BODYPART.LEFT_INDEX_FINGER.rawValue,
                               modelType: modelType, exerciseLead: exerciseLead, observerId: Posenet.ObserverID.LEFT_INDEX_FINGER.rawValue)
      self.thumb = BodyElementOLD(label: Posenet.BODYPART.LEFT_THUMB.rawValue,
                               modelType: modelType, exerciseLead: exerciseLead, observerId: Posenet.ObserverID.LEFT_THUMB.rawValue)
    case .RIGHT:
      observerId = Posenet.ObserverID.RIGHT_ARM.rawValue
      self.shoulder = BodyElementOLD(label: Posenet.BODYPART.RIGHT_SHOULDER.rawValue,
                                  modelType: modelType, exerciseLead: exerciseLead, observerId: Posenet.ObserverID.RIGHT_SHOULDER.rawValue)
      self.elbow = BodyElementOLD(label: Posenet.BODYPART.RIGHT_ELBOW.rawValue,
                               modelType: modelType, exerciseLead: exerciseLead, observerId: Posenet.ObserverID.RIGHT_SHOULDER.rawValue)
      self.wrist = BodyElementOLD(label: Posenet.BODYPART.RIGHT_WRIST.rawValue,
                               modelType: modelType, exerciseLead: exerciseLead, observerId: Posenet.ObserverID.RIGHT_WRIST.rawValue)
      self.pinky = BodyElementOLD(label: Posenet.BODYPART.RIGHT_PINKY_FINGER.rawValue,
                               modelType: modelType, exerciseLead: exerciseLead, observerId: Posenet.ObserverID.RIGHT_PINKY_FINGER.rawValue)
      self.index = BodyElementOLD(label: Posenet.BODYPART.RIGHT_INDEX_FINGER.rawValue,
                               modelType: modelType, exerciseLead: exerciseLead, observerId: Posenet.ObserverID.RIGHT_INDEX_FINGER.rawValue)
      self.thumb = BodyElementOLD(label: Posenet.BODYPART.RIGHT_THUMB.rawValue,
                               modelType: modelType, exerciseLead: exerciseLead, observerId: Posenet.ObserverID.RIGHT_THUMB.rawValue)
    }
    underArm = Bone(bodyElement1: wrist, bodyElement2: elbow)
    upperArm = Bone(bodyElement1: elbow, bodyElement2: shoulder)
    
    super.init(label: "Arm", modelType: modelType, exerciseLead: exerciseLead, observerId: observerId, person: person)
    self.appendToAppropriateSuperParts()
  }
  
  func appendToAppropriateSuperParts() {
    bones.append(underArm)
    bones.append(upperArm)
    bodyElements.append(shoulder)
    bodyElements.append(elbow)
    bodyElements.append(wrist)
    bodyElements.append(pinky)
    bodyElements.append(index)
    bodyElements.append(thumb)
  }
  
  public override func parse(detectedLocations: [DetectionLocation], infoBlob: InfoBlob) {
    super.parse(detectedLocations: detectedLocations, infoBlob: infoBlob)
    bones.forEach { (bone) in
      bone.updateLength()
    }
  }
  
  // MARK: Properties Get/Set
  public override func getName() -> String {
    return "\(self.orientation.rawValue ) arm"
  }
  
  // MARK: Calculate Arm Properties.
  public func getShoulderAngle() -> Double {
    let shoulderLocation: DetectionLocation? = shoulder.getDetectedLocation()
    let elblowLocation: DetectionLocation? = elbow.getDetectedLocation()
    
    let hipLocation: DetectionLocation?
    if orientation == Orientation.LEFT {
      hipLocation = person?.leftLeg!.hip.getDetectedLocation()
    } else {
      hipLocation = person?.rightLeg!.hip.getDetectedLocation()
    }
    
    if shoulderLocation == nil || elblowLocation == nil || hipLocation == nil {
      return MathUtil.BadAngleOutput.nul.rawValue
    }
    return MathUtil.calculateAngle3Points(pA: elblowLocation, pB: shoulderLocation, pC: hipLocation, negativeAngle: false)
  }
  
  public func getElbowFlexion() -> Double {
    let shoulderLocation: DetectionLocation? = shoulder.getDetectedLocation()
    let elbowLocation: DetectionLocation? =  elbow.getDetectedLocation()
    let wristLocation: DetectionLocation? = wrist.getDetectedLocation()
    if shoulderLocation == nil || elbowLocation == nil || wristLocation == nil {
      return MathUtil.BadAngleOutput.nul.rawValue
    }
    return MathUtil.calculateAngle3Points(pA: shoulderLocation, pB: elbowLocation, pC: wristLocation, negativeAngle: false)
  }
  
  public func getSidewaysExtendedCosine() -> Double {
    let shoulderLocation: DetectionLocation? = shoulder.getDetectedLocation()
    let elbowLocation: DetectionLocation? =  elbow.getDetectedLocation()
    let wristLocation: DetectionLocation? = wrist.getDetectedLocation()
    if shoulderLocation == nil || elbowLocation == nil || wristLocation == nil {
      return MathUtil.BadAngleOutput.sim.rawValue
    }
    let shoulderX: Double = shoulderLocation!.getX()
    let shoulderY: Double = shoulderLocation!.getY()
    
    let scaledElbowX: Double = (elbowLocation!.getX() - shoulderX) * scalar
    let scaledElbowY: Double = (elbowLocation!.getY() - shoulderY) * scalar
    
    let scaledWristX: Double = (wristLocation!.getX() - shoulderX) * scalar
    let scaledWristY: Double = (wristLocation!.getY() - shoulderY) * scalar
    
    let xsim: Double = scaledElbowX * scaledWristX
    let ysim: Double = scaledElbowY * scaledWristY
    let elbownorm: Double = sqrt(pow(scaledElbowX, 2) + pow(scaledElbowY, 2))
    let wristnorm: Double = sqrt(pow(scaledWristX, 2) + pow(scaledWristY, 2))
    
    let cosineSim: Double = (xsim + ysim) / (elbownorm * wristnorm)
    return cosineSim
  }
  
  public func sidewaysExtended() -> Bool {
    return getSidewaysExtendedCosine() > EXTENSION_THRESHOLD
  }
  
  public func getLength() -> Double {
    return underArm.getFullLength() + upperArm.getFullLength()
  }
}
