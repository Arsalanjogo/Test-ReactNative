//
//  LegDetection.swift
//  jogo
//
//  Created by arham on 14/03/2021.
//

import Foundation

class LegDetection: BodyPartDetection {
  // Leg Representation for MLKit Posenet.
  enum Orientation: String {
    case LEFT = "Left"
    case RIGHT = "Right"
  }
  
  public final var hip: BodyElementOLD
  public final var knee: BodyElementOLD
  public final var ankle: BodyElementOLD
  public final var heel: BodyElementOLD
  public final var index: BodyElementOLD
  public final var lowerLeg: Bone
  public final var upperLeg: Bone

  var orientation: Orientation

  public final var heelIndex, ankleHeel: Bone
  
  // MARK: Lifecycle
  init(orientation: Orientation, exerciseLead: Bool, person: PersonDetection, modelType: ModelManager.MODELTYPE) {
    self.orientation = orientation
    var observerId: Int
    switch orientation {
    case .LEFT:
      observerId = Posenet.ObserverID.LEFT_LEG.rawValue
      hip = BodyElementOLD(label: Posenet.BODYPART.LEFT_HIP.rawValue, modelType: modelType, exerciseLead: exerciseLead, observerId: Posenet.ObserverID.LEFT_HIP.rawValue)
      knee = BodyElementOLD(label: Posenet.BODYPART.LEFT_KNEE.rawValue, modelType: modelType, exerciseLead: exerciseLead, observerId: Posenet.ObserverID.LEFT_KNEE.rawValue)
      ankle = BodyElementOLD(label: Posenet.BODYPART.LEFT_ANKLE.rawValue, modelType: modelType, exerciseLead: exerciseLead, observerId: Posenet.ObserverID.LEFT_ANKLE.rawValue)
      heel = BodyElementOLD(label: Posenet.BODYPART.LEFT_HEEL.rawValue, modelType: modelType, exerciseLead: exerciseLead, observerId: Posenet.ObserverID.LEFT_HEEL.rawValue)
      index = BodyElementOLD(label: Posenet.BODYPART.LEFT_TOE.rawValue, modelType: modelType, exerciseLead: exerciseLead, observerId: Posenet.ObserverID.LEFT_TOE.rawValue)
    case .RIGHT:
      observerId = Posenet.ObserverID.RIGHT_LEG.rawValue
      hip = BodyElementOLD(label: Posenet.BODYPART.RIGHT_HIP.rawValue, modelType: modelType, exerciseLead: exerciseLead, observerId: Posenet.ObserverID.RIGHT_HIP.rawValue)
      knee = BodyElementOLD(label: Posenet.BODYPART.RIGHT_KNEE.rawValue, modelType: modelType, exerciseLead: exerciseLead, observerId: Posenet.ObserverID.RIGHT_KNEE.rawValue)
      ankle = BodyElementOLD(label: Posenet.BODYPART.RIGHT_ANKLE.rawValue, modelType: modelType, exerciseLead: exerciseLead, observerId: Posenet.ObserverID.RIGHT_ANKLE.rawValue)
      heel = BodyElementOLD(label: Posenet.BODYPART.RIGHT_HEEL.rawValue, modelType: modelType, exerciseLead: exerciseLead, observerId: Posenet.ObserverID.RIGHT_HEEL.rawValue)
      index = BodyElementOLD(label: Posenet.BODYPART.RIGHT_TOE.rawValue, modelType: modelType, exerciseLead: exerciseLead, observerId: Posenet.ObserverID.RIGHT_TOE.rawValue)
    }
    lowerLeg = Bone(bodyElement1: ankle, bodyElement2: knee)
    upperLeg = Bone(bodyElement1: knee, bodyElement2: hip)
    heelIndex = Bone(bodyElement1: heel, bodyElement2: index)
    ankleHeel = Bone(bodyElement1: ankle, bodyElement2: heel)
    super.init(label: "Leg", modelType: modelType, exerciseLead: exerciseLead, observerId: observerId, person: person)
    bodyElements.append(hip)
    bodyElements.append(knee)
    bodyElements.append(ankle)
    bodyElements.append(heel)
    bodyElements.append(index)
    bones.append(lowerLeg)
    bones.append(upperLeg)
    bones.append(heelIndex)
    bones.append(ankleHeel)
  }
  
  public override func parse(detectedLocations: [DetectionLocation], infoBlob: InfoBlob) {
    super.parse(detectedLocations: detectedLocations, infoBlob: infoBlob)
    bones.forEach { (bone) in
      bone.updateLength()
    }
  }
  
  // MARK: Calculate Properties
  public func getHipAngle() -> Double {
    let shoulderLocation: DetectionLocation?
    if orientation == Orientation.LEFT {
      shoulderLocation = person?.leftArm!.shoulder.getDetectedLocation()
    } else {
      shoulderLocation = person?.rightArm!.shoulder.getDetectedLocation()
    }
    return MathUtil.calculateAngle3Points(pA: shoulderLocation,
                                          pB: hip.getDetectedLocation(),
                                          pC: ankle.getDetectedLocation(),
                                          negativeAngle: false)
  }
  
  public func getLegAngle() -> Double {
    let shoulderLocation: DetectionLocation?
    if orientation == Orientation.LEFT {
      shoulderLocation = person?.leftArm!.shoulder.getDetectedLocation()
    } else {
      shoulderLocation = person?.rightArm!.shoulder.getDetectedLocation()
    }
    return MathUtil.calculateAngle3Points(pA: shoulderLocation,
                                          pB: hip.getDetectedLocation(),
                                          pC: ankle.getDetectedLocation(),
                                          negativeAngle: true)
    
  }
  
  public func getKneeAngle() -> Double {
    return MathUtil.calculateAngle3Points(pA: hip.getDetectedLocation(), pB: knee.getDetectedLocation(), pC: ankle.getDetectedLocation(), negativeAngle: true)
  }
  
  public func getLength() -> Double {
    return lowerLeg.getFullLength() + upperLeg.getFullLength()
  }
  
  public override func getName() -> String {
    return "\(self.orientation.rawValue) leg"
  }
}
