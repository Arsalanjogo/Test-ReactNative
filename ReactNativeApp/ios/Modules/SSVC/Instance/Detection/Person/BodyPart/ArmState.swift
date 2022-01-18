//
//  ArmState.swift
//  jogo
//
//  Created by Mohsin on 20/10/2021.
//

import Foundation

public class ArmState: BodyPartState {
  // Represents the arm for the MLKit Posenet Model only.
  
  public enum Orientation: String {
    case LEFT = "Left"
    case RIGHT = "Right"
  }
  
  public final let EXTENSION_THRESHOLD: Double = 0.90
  public final let scalar: Double = 10.0
  
  var orientation: Orientation
  
  public final var shoulder: BodyElement
  public final var elbow: BodyElement
  public final var wrist: BodyElement
  
  public final var pinky: BodyElement
  public final var index: BodyElement
  public final var thumb: BodyElement
  
  public final var underArm: BoneState
  public final var upperArm: BoneState
  
  // MARK: Lifecycle
  init(orientation: Orientation, exerciseLead: Bool, modelType: ModelManager.MODELTYPE) {
    self.orientation = orientation
    var observerId: Int
    switch orientation {
    case .LEFT:
      observerId = Posenet.ObserverID.LEFT_ARM.rawValue
      self.shoulder = BodyElement(label: Posenet.BODYPART.LEFT_SHOULDER.rawValue,
                                  modelType: modelType, exerciseLead: exerciseLead, observerId: Posenet.ObserverID.LEFT_SHOULDER.rawValue)
      self.elbow = BodyElement(label: Posenet.BODYPART.LEFT_ELBOW.rawValue,
                               modelType: modelType, exerciseLead: exerciseLead, observerId: Posenet.ObserverID.LEFT_SHOULDER.rawValue)
      self.wrist = BodyElement(label: Posenet.BODYPART.LEFT_WRIST.rawValue,
                               modelType: modelType, exerciseLead: exerciseLead, observerId: Posenet.ObserverID.LEFT_WRIST.rawValue)
      self.pinky = BodyElement(label: Posenet.BODYPART.LEFT_PINKY_FINGER.rawValue,
                               modelType: modelType, exerciseLead: exerciseLead, observerId: Posenet.ObserverID.LEFT_PINKY_FINGER.rawValue)
      self.index = BodyElement(label: Posenet.BODYPART.LEFT_INDEX_FINGER.rawValue,
                               modelType: modelType, exerciseLead: exerciseLead, observerId: Posenet.ObserverID.LEFT_INDEX_FINGER.rawValue)
      self.thumb = BodyElement(label: Posenet.BODYPART.LEFT_THUMB.rawValue,
                               modelType: modelType, exerciseLead: exerciseLead, observerId: Posenet.ObserverID.LEFT_THUMB.rawValue)
    case .RIGHT:
      observerId = Posenet.ObserverID.RIGHT_ARM.rawValue
      self.shoulder = BodyElement(label: Posenet.BODYPART.RIGHT_SHOULDER.rawValue,
                                  modelType: modelType, exerciseLead: exerciseLead, observerId: Posenet.ObserverID.RIGHT_SHOULDER.rawValue)
      self.elbow = BodyElement(label: Posenet.BODYPART.RIGHT_ELBOW.rawValue,
                               modelType: modelType, exerciseLead: exerciseLead, observerId: Posenet.ObserverID.RIGHT_SHOULDER.rawValue)
      self.wrist = BodyElement(label: Posenet.BODYPART.RIGHT_WRIST.rawValue,
                               modelType: modelType, exerciseLead: exerciseLead, observerId: Posenet.ObserverID.RIGHT_WRIST.rawValue)
      self.pinky = BodyElement(label: Posenet.BODYPART.RIGHT_PINKY_FINGER.rawValue,
                               modelType: modelType, exerciseLead: exerciseLead, observerId: Posenet.ObserverID.RIGHT_PINKY_FINGER.rawValue)
      self.index = BodyElement(label: Posenet.BODYPART.RIGHT_INDEX_FINGER.rawValue,
                               modelType: modelType, exerciseLead: exerciseLead, observerId: Posenet.ObserverID.RIGHT_INDEX_FINGER.rawValue)
      self.thumb = BodyElement(label: Posenet.BODYPART.RIGHT_THUMB.rawValue,
                               modelType: modelType, exerciseLead: exerciseLead, observerId: Posenet.ObserverID.RIGHT_THUMB.rawValue)
    }
    underArm = BoneState(bodyPart1: wrist, bodyPart2: elbow)
    upperArm = BoneState(bodyPart1: elbow, bodyPart2: shoulder)
    
    super.init(label: "ARM", modelType: modelType, exerciseLead: exerciseLead, observerId: observerId)
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
