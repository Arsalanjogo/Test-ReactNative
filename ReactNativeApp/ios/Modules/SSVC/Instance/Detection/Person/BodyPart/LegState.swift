//
//  LegState.swift
//  jogo
//
//  Created by Mohsin on 18/10/2021.
//

import Foundation

public class LegState: BodyPartState{
  // Leg Representation for MLKit Posenet.
  enum Orientation: String {
    case LEFT = "Left"
    case RIGHT = "Right"
  }
  
  public final var hip: BodyElement
  public final var knee: BodyElement
  public final var ankle: BodyElement
  public final var heel: BodyElement
  public final var index: BodyElement
  public final var lowerLeg: BoneState
  public final var upperLeg: BoneState

  var orientation: Orientation

  public final var heelIndex, ankleHeel: BoneState
  
  // MARK: Lifecycle
  init(orientation: Orientation, exerciseLead: Bool, modelType: ModelManager.MODELTYPE) {
    self.orientation = orientation
    var observerId: Int
    switch orientation {
    case .LEFT:
      observerId = Posenet.ObserverID.LEFT_LEG.rawValue
      hip = BodyElement(label: Posenet.BODYPART.LEFT_HIP.rawValue, modelType: modelType, exerciseLead: exerciseLead, observerId: Posenet.ObserverID.LEFT_HIP.rawValue)
      knee = BodyElement(label: Posenet.BODYPART.LEFT_KNEE.rawValue, modelType: modelType, exerciseLead: exerciseLead, observerId: Posenet.ObserverID.LEFT_KNEE.rawValue)
      ankle = BodyElement(label: Posenet.BODYPART.LEFT_ANKLE.rawValue, modelType: modelType, exerciseLead: exerciseLead, observerId: Posenet.ObserverID.LEFT_ANKLE.rawValue)
      heel = BodyElement(label: Posenet.BODYPART.LEFT_HEEL.rawValue, modelType: modelType, exerciseLead: exerciseLead, observerId: Posenet.ObserverID.LEFT_HEEL.rawValue)
      index = BodyElement(label: Posenet.BODYPART.LEFT_TOE.rawValue, modelType: modelType, exerciseLead: exerciseLead, observerId: Posenet.ObserverID.LEFT_TOE.rawValue)
    case .RIGHT:
      observerId = Posenet.ObserverID.RIGHT_LEG.rawValue
      hip = BodyElement(label: Posenet.BODYPART.RIGHT_HIP.rawValue, modelType: modelType, exerciseLead: exerciseLead, observerId: Posenet.ObserverID.RIGHT_HIP.rawValue)
      knee = BodyElement(label: Posenet.BODYPART.RIGHT_KNEE.rawValue, modelType: modelType, exerciseLead: exerciseLead, observerId: Posenet.ObserverID.RIGHT_KNEE.rawValue)
      ankle = BodyElement(label: Posenet.BODYPART.RIGHT_ANKLE.rawValue, modelType: modelType, exerciseLead: exerciseLead, observerId: Posenet.ObserverID.RIGHT_ANKLE.rawValue)
      heel = BodyElement(label: Posenet.BODYPART.RIGHT_HEEL.rawValue, modelType: modelType, exerciseLead: exerciseLead, observerId: Posenet.ObserverID.RIGHT_HEEL.rawValue)
      index = BodyElement(label: Posenet.BODYPART.RIGHT_TOE.rawValue, modelType: modelType, exerciseLead: exerciseLead, observerId: Posenet.ObserverID.RIGHT_TOE.rawValue)
    }
    lowerLeg = BoneState(bodyPart1: ankle, bodyPart2: knee)
    upperLeg = BoneState(bodyPart1: knee, bodyPart2: hip)
    heelIndex = BoneState(bodyPart1: heel, bodyPart2: index)
    ankleHeel = BoneState(bodyPart1: ankle, bodyPart2: heel)
    super.init(label: "LEG", modelType: modelType, exerciseLead: exerciseLead, observerId: observerId)
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
