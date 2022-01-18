//
//  BoneState.swift
//  jogo
//
//  Created by Mohsin on 18/10/2021.
//

import Foundation

public class BoneState: State {
  
  var bodyPart1: BodyElement?
  var bodyPart2: BodyElement?
  var boneName: String
  
  private var curLength: Double = 0
  private var maxLength: Double = 0
  
  init(bodyPart1: BodyElement, bodyPart2: BodyElement) {
    self.bodyPart1 = bodyPart1
    self.bodyPart2 = bodyPart2
    self.boneName = "\(bodyPart1.label) \(bodyPart2.label)"
  }
  
  public func updateLength() {
    let l1: DetectionLocation? = self.bodyPart1?.getLocation()
    let l2: DetectionLocation? = self.bodyPart2?.getLocation()
    if l1 == nil || l2 == nil { return }
    if !(l1?.locationKnown() ?? false) || !(l2?.locationKnown() ?? false) { return }
    curLength = (curLength * 0.5) + (l1!.getEuclideanDistance(location: l2!) * 0.5)
    maxLength = max(curLength, maxLength)
  }
  
  // MARK: Properties Get
  public func getFullLength() -> Double {
    return maxLength
  }
  
  public func getBoneName() -> String {
    return boneName
  }
  
  public func getBodyPart1() -> BodyElement {
    return bodyPart1 ?? BodyElement(label: "nil", modelType: .SKIP, exerciseLead: false, observerId: -1)
  }
  
  public func getBodyPart2() -> BodyElement {
    return bodyPart2 ?? BodyElement(label: "nil", modelType: .SKIP, exerciseLead: false, observerId: -1)
  }
  
  public override func cleanup() {
    super.cleanup()
    self.bodyPart1 = nil
    self.bodyPart2 = nil
  }
  
  
  public override func getDebugText() -> String {
    return ""
  }
  
}
