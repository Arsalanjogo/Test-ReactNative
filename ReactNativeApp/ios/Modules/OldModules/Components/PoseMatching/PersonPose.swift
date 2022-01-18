//
//  PersonPose.swift
//  jogo
//
//  Created by arham on 24/03/2021.
//

import Foundation

class PersonPose: GenericPose<PersonPose> {
  // The pose matching object for the Person.
  //
  
  internal final var person: PersonDetection
  
  // MARK: Lifecycle
  init(person: PersonDetection) {
    self.person = person
  }
  
  // MARK: Predefined general scenarios
  public func person(personSubPose: PersonSubPose, tag: String) -> PersonPose {
    y(subpose: {[unowned self] in
        personSubPose.match(person: self.person)}, poseTag: tag)
    return self
  }
  
  public func minLegAngle(angle: Double) -> PersonPose {
    y(subpose: {[unowned self] in
        return self.person.leftLeg!.getLegAngle() > angle &&
          self.person.rightLeg!.getLegAngle() > angle},
      poseTag: "minLegAngle")
    extraDraw(method: { "\(self.person.leftLeg!.getLegAngle()) > \(angle) && \(self.person.rightLeg!.getLegAngle()) > \(angle)" })
    return self
  }
  
  public func maxLegAngle(angle: Double) -> PersonPose {
    y(subpose: {[unowned self] in
        return self.person.leftLeg!.getLegAngle() < angle &&
          self.person.rightLeg!.getLegAngle() < angle},
      poseTag: "maxLegAngle")
    extraDraw(method: { "\(self.person.leftLeg!.getLegAngle()) < \(angle) && \(self.person.rightLeg!.getLegAngle()) < \(angle)" })
    return self
  }
  
  public func minShoulderAngle(angle: Double) -> PersonPose {
    y(subpose: {[unowned self] in
      self.person.leftArm!.getShoulderAngle() > angle &&
        self.person.rightArm!.getShoulderAngle() > angle
      
    },
    poseTag: "minShoulderAngle")
    extraDraw(method: { "\(self.person.leftArm!.getShoulderAngle()) > \(angle) && \(self.person.rightArm!.getShoulderAngle()) > \(angle)" })
    return self
  }
  
  public func maxShoulderAngle(angle: Double) -> PersonPose {
    y(subpose: {[unowned self] in
        self.person.leftArm!.getShoulderAngle() < angle &&
          self.person.rightArm!.getShoulderAngle() < angle},
      poseTag: "maxShoulderAngle")
    extraDraw(method: { "\(self.person.leftArm!.getShoulderAngle()) < \(angle) && \(self.person.rightArm!.getShoulderAngle()) < \(angle)" })
    return self
  }
  
  private func getSidewaysLeft() -> SubPose {
    return {[unowned self] in
      self.person.leftArm!.shoulder.getX()! < self.person.leftLeg!.hip.getX()! &&
        self.person.leftArm!.shoulder.getX()! < self.person.rightLeg!.hip.getX()! &&
        self.person.rightArm!.shoulder.getX()! < self.person.leftLeg!.hip.getX()! &&
        self.person.rightArm!.shoulder.getX()! < self.person.rightLeg!.hip.getX()!
    }
  }
  
  private func getSidewaysRight() -> SubPose {
    return {[unowned self] in
      self.person.leftArm!.shoulder.getX()! > self.person.leftLeg!.hip.getX()! &&
        self.person.leftArm!.shoulder.getX()! > self.person.rightLeg!.hip.getX()! &&
        self.person.rightArm!.shoulder.getX()! > self.person.leftLeg!.hip.getX()! &&
        self.person.rightArm!.shoulder.getX()! > self.person.rightLeg!.hip.getX()!
    }
  }
  
  public func sideWaysLeft() -> PersonPose {
    y(subpose: getSidewaysLeft(), poseTag: "sidewaysLeft")
    return self
  }
  
  public func sideWaysRight() -> PersonPose {
    y(subpose: getSidewaysRight(), poseTag: "sidewaysRight")
    return self
  }
  
  public func upperBodySideWays() -> PersonPose {
    let sideWaysLeft: SubPose = getSidewaysLeft()
    let sideWaysRight: SubPose = getSidewaysRight()
    y(subpose: { sideWaysLeft() && sideWaysRight() }, poseTag: "sideways")
    return self
  }
  
  public func slopeXAxis(x1: Double,
                         x2: Double,
                         y1: Double,
                         y2: Double,
                         min: Double,
                         max: Double) -> PersonPose {
    y(subpose: {
      let slope: Double = MathUtil.calculateSlopeWithXAxis(x1: x1, x2: x2, y1: y1, y2: y2)
      return slope > min && slope < max
    }, poseTag: "\(x1),\(y1),\(x2),\(y2)")
    extraDraw(method: { "\(x1),\(y1),\(x2),\(y2) : \(MathUtil.calculateSlopeWithXAxis(x1: x1, x2: x2, y1: y1, y2: y2))" })
    return self
  }
  public func slopeXAxis(o1: ObjectDetection, o2: ObjectDetection, min: Double, max: Double) -> PersonPose {
    y(subpose: {
      let slope: Double = MathUtil.calculateSlopeWithXAxis(o1: o1, o2: o2)
      return slope > min && slope < max
    }, poseTag: "\(o1.label), \(o2.label)")
    
    extraDraw(method: { "\(o1.label), \(o2.label) : \(MathUtil.calculateSlopeWithXAxis(o1: o1, o2: o2))" })
    return self
  }
  
  public func angle(o1: ObjectDetection,
                    o2: ObjectDetection,
                    o3: ObjectDetection,
                    minAngle: Double?,
                    maxAngle: Double?) -> PersonPose {
    y(subpose: {
      let angle: Double = MathUtil.calculateAngle3Points(pA: o1, pB: o2, pC: o3, negativeAngle: false)
      let a: Bool = minAngle == nil ? true : angle > minAngle!
      let b: Bool = maxAngle == nil ? true: angle < maxAngle!
      print("extra: \(o1.label), \(o2.label), \(o3.label) = \(angle)")
      return a && b
    }, poseTag: "\(o1.label), \(o2.label), \(o3.label)")
    extraDraw(method: {
      "extra: \(o1.label), \(o2.label), \(o3.label) = \(MathUtil.calculateAngle3Points(pA: o1, pB: o2, pC: o3, negativeAngle: false))"
    })
    return self
  }
  
  public func angleNotBetween(o1: ObjectDetection,
                              o2: ObjectDetection,
                              o3: ObjectDetection,
                              minAngle: Double?,
                              maxAngle: Double?) -> PersonPose {
    y(subpose: {
      let angle: Double = MathUtil.calculateAngle3Points(pA: o1, pB: o2, pC: o3, negativeAngle: false)
      let a: Bool = minAngle == nil ? true : angle < minAngle!
      let b: Bool = maxAngle == nil ? true: angle > maxAngle!
      print("extra: \(o1.label), \(o2.label), \(o3.label) = \(angle)")
      return a || b
    }, poseTag: "\(o1.label), \(o2.label), \(o3.label)")
    extraDraw(method: {
      "extra: \(o1.label), \(o2.label), \(o3.label) = \(MathUtil.calculateAngle3Points(pA: o1, pB: o2, pC: o3, negativeAngle: false))"
    })
    return self
  }
  
  public func angleWithXAxis(o1: ObjectDetection,
                             o2: ObjectDetection,
                             o3: ObjectDetection,
                             o4: ObjectDetection,
                             minAngle: Double?,
                             maxAngle: Double?) -> PersonPose {
    y(subpose: {
      let angle: Double = MathUtil.calculateAngleWithXAxis(o1: o1, o2: o2)
      let a: Bool = minAngle == nil ? true : angle > minAngle!
      let b: Bool = maxAngle == nil ? true: angle < maxAngle!
      
      let angle2: Double = MathUtil.calculateAngleWithXAxis(o1: o3, o2: o4)
      let c: Bool = minAngle == nil ? true : angle2 > minAngle!
      let d: Bool = maxAngle == nil ? true: angle2 < maxAngle!
      
      return (a && b) || (c && d)
    }, poseTag: "\(o1.label), \(o2.label), \(o3.label), \(o4.label)")
    return self
  }
  
  public func angleWithXAxis(o1: ObjectDetection, o2: ObjectDetection, minAngle: Double?, maxAngle: Double?) -> PersonPose {
    y(subpose: {
      let angle: Double = MathUtil.calculateAngleWithXAxis(o1: o1, o2: o2)
      let a: Bool = minAngle == nil ? true : angle > minAngle!
      let b: Bool = maxAngle == nil ? true: angle < maxAngle!
      return a && b
    }, poseTag: "\(o1.label), \(o2.label)")
    extraDraw(method: {
      "\(o1.label), \(o2.label) : \(MathUtil.calculateAngleWithXAxis(o1: o1, o2: o2))"
    })
    return self
  }
  
  public func angleWithYAxis(o1: ObjectDetection, o2: ObjectDetection, minAngle: Double?, maxAngle: Double?) -> PersonPose {
    y(subpose: {
      let angle: Double = MathUtil.calculateAngleWithYAxis(o1: o1, o2: o2)
      let a: Bool = minAngle == nil ? true : angle > minAngle!
      let b: Bool = maxAngle == nil ? true: angle < maxAngle!
      return a && b
    }, poseTag: "\(o1.label), \(o2.label)")
    extraDraw(method: {
      "\(o1.label), \(o2.label) : \(MathUtil.calculateAngleWithYAxis(o1: o1, o2: o2))"
    })
    return self
  }
  
  public func isBodyUpright() -> PersonPose {
    y(subpose: { [unowned self] in
      let shoulder: ObjectDetection = self.person.leftArm!.shoulder.getY()! < self.person.rightArm!.shoulder.getY()! ?
        self.person.leftArm!.shoulder : self.person.rightArm!.shoulder
      let hip: ObjectDetection = self.person.leftLeg!.hip.getY()! < self.person.rightLeg!.hip.getY()! ?
        self.person.leftLeg!.hip : self.person.rightLeg!.hip
      let xDiffSH = abs(shoulder.getX()! - hip.getX()!)
      let yDiffSH = abs(shoulder.getY()! - hip.getY()!)
      return xDiffSH < yDiffSH
    }, poseTag: "bodyUpright")
    return self
  }
  
  public func isStandingStraight() -> PersonPose {
    y(subpose: { [unowned self] in
      let minAngle: Double = 169
      let maxAngle: Double = 181
      let leftSideAngle: Double = MathUtil.calculateAngle3Points(pA: person.leftArm!.shoulder, pB: person.leftLeg!.hip, pC: person.leftLeg!.knee, negativeAngle: false)
      let rightSideAngle: Double = MathUtil.calculateAngle3Points(pA: person.rightArm!.shoulder, pB: person.rightLeg!.hip, pC: person.rightLeg!.knee, negativeAngle: false)
      let a: Bool = leftSideAngle >= minAngle
      let b: Bool = leftSideAngle <= maxAngle
      let c: Bool = rightSideAngle >= minAngle
      let d: Bool = rightSideAngle <= maxAngle
      return a && b && c && d
    }, poseTag: "standingStraight")
    return self
  }
  
  public func isBackFlat() -> PersonPose {
    y(subpose: {[unowned self] in 
      let faceX: Double = self.person.face!.nose.getX()!
      let shoulderX: Double = self.person.leftArm!.shoulder.getY()! < self.person.rightArm!.shoulder.getY()! ?
        self.person.leftArm!.shoulder.getX()! : self.person.rightArm!.shoulder.getX()!
      let hipX: Double = self.person.leftLeg!.hip.getY()! < self.person.rightLeg!.hip.getY()! ?
        self.person.leftLeg!.hip.getX()! : self.person.rightLeg!.hip.getX()!
      return ((faceX < shoulderX && shoulderX < hipX) || (faceX > shoulderX && shoulderX > hipX))
    }, poseTag: "isBackFlat")
    return self
  }
  
  public func isLayingFlat() -> PersonPose {
    y(subpose: {[unowned self] in
      
      let highestHip = self.person.leftLeg!.hip.getY()! < self.person.rightLeg!.hip.getY()! ?
        self.person.leftLeg!.hip.getDetectedLocation() : self.person.rightLeg!.hip.getDetectedLocation()
      
      let highestShoulder = self.person.leftArm!.shoulder.getY()! < self.person.rightArm!.shoulder.getY()! ?
        self.person.leftArm!.shoulder.getDetectedLocation() : self.person.rightArm!.shoulder.getDetectedLocation()
      
      let lowestShoulder = self.person.leftArm!.shoulder.getY()! > self.person.rightArm!.shoulder.getY()! ?
        self.person.leftArm!.shoulder.getDetectedLocation() : self.person.rightArm!.shoulder.getDetectedLocation()
      
      let shoulderDistance = highestShoulder!.getEuclideanDistance(location: lowestShoulder!)
      
      let hipShoulderDistance = highestHip!.getEuclideanDistance(location: highestShoulder!)
      
      // If shoulder distance is greater than the half of hipShoulderDistance then person is laying down flat.
      return shoulderDistance >= (hipShoulderDistance / 2)
    }, poseTag: "isLayingFlat")
    return self
  }
  
  public func objectHasntMoved(object: BallDetection, thresholdDistance: Double, nullDistance: Double, frameLookback: Int = 15) -> PersonPose {
    y(subpose: {
      let prevObjLocation: DetectionLocation? = object.getDetectionLocationNBack(lookBack: frameLookback)
      if prevObjLocation == nil {
        return true
      }
      let curObjLocation: DetectionLocation? = object.getLocation()
      let distance: Double = curObjLocation?.getEuclideanDistance(location: prevObjLocation!) ?? nullDistance
      if distance < thresholdDistance {
        return true
      }
      return false
    }, poseTag: "objectHasntMoved")
    return self
  }
  
  public func leftLegCloserToHips() -> PersonPose {
    y(subpose: {[unowned self] in
      let lAnkleHip: Double = MathUtil.getDistance(a: self.person.leftLeg!.ankle, b: self.person.leftLeg!.hip)
      let rAnkleHip: Double = MathUtil.getDistance(a: self.person.rightLeg!.ankle, b: self.person.rightLeg!.hip)
      return lAnkleHip < rAnkleHip
    }, poseTag: "leftLegCloserToHips")
    return self
  }
  
  public func rightLegCloserToHips() -> PersonPose {
    y(subpose: {[unowned self] in
      let lAnkleHip: Double = MathUtil.getDistance(a: self.person.leftLeg!.ankle, b: self.person.leftLeg!.hip)
      let rAnkleHip: Double = MathUtil.getDistance(a: self.person.rightLeg!.ankle, b: self.person.rightLeg!.hip)
      return rAnkleHip < lAnkleHip
    }, poseTag: "leftLegCloserToHips")
    return self
  }
  
  public func kneeAngleBetween(minAngle: Double, maxAngle: Double) -> PersonPose {
    y(subpose: {[unowned self] in
      let lAnkleHip: Double = person.leftLeg!.getKneeAngle()
      let rAnkleHip: Double = person.rightLeg!.getKneeAngle()
      let l: Bool = lAnkleHip > minAngle && lAnkleHip < maxAngle
      let r: Bool = rAnkleHip > minAngle && rAnkleHip < maxAngle
      return l || r
    }, poseTag: "kneeAngleBetween")
    extraDraw(method: { "\(minAngle) < \(self.person.leftLeg?.getKneeAngle() ?? -1) < \(maxAngle) && \(minAngle) < \(self.person.rightLeg?.getKneeAngle() ?? -1) < \(maxAngle)" })
    return self
  }
  
  public func hipAngleBetween(minAngle: Double, maxAngle: Double) -> PersonPose {
    y(subpose: {[unowned self] in
      let lAngleHip: Double = person.leftLeg!.getLegAngle()
      let rAngleHip: Double = person.rightLeg!.getLegAngle()
      let l: Bool = lAngleHip > minAngle && lAngleHip < maxAngle
      let r: Bool = rAngleHip > minAngle && rAngleHip < maxAngle
      return l || r
    }, poseTag: "hipAngleBetween")
    extraDraw(method: { "\(minAngle) < \(self.person.leftLeg?.getLegAngle() ?? -1 ) < \(maxAngle) && \(minAngle) < \(self.person.rightLeg?.getLegAngle() ?? -1) < \(maxAngle)" })
    return self
  }
  
  public func slopeBetween2Points(obj1: ObjectDetection,
                                  obj2: ObjectDetection,
                                  obj3: ObjectDetection,
                                  obj4: ObjectDetection,
                                  min: Double?,
                                  max: Double?) -> PersonPose {
    y(subpose: {
      let y1: Double = MathUtil.getMean(a: obj1, b: obj2, axis: .y)
      let x1: Double = MathUtil.getMean(a: obj1, b: obj2, axis: .x)
      
      let y2: Double = MathUtil.getMean(a: obj3, b: obj4, axis: .y)
      let x2: Double = MathUtil.getMean(a: obj3, b: obj4, axis: .x)
      
      let slope: Double = abs((y1 - y2) / (x1 - x2))
      let moreThanMin: Bool = min == nil ? true : slope > min!
      let lessThanMax: Bool = max == nil ? true : slope < max!
      return moreThanMin && lessThanMax
    }, poseTag: "slopeBetweenAverageOf2Points")
    return self
  }
  
  public func belowGroundLine(d1: ObjectDetection, person: PersonDetection) -> PersonPose {
    y(subpose: { d1.getY() ?? -1000 > person.getGroundLine() - 0.03 }, poseTag: "\(d1.label) v \(person.getGroundLine() - 0.03)")
    return self
  }
  
  public func aboveGroundLine(d1: ObjectDetection, person: PersonDetection) -> PersonPose {
    y(subpose: { d1.getY() ?? -1000 < person.getGroundLine() - 0.03 }, poseTag: "\(d1.label) ^ \(person.getGroundLine() - 0.03)")
    return self
  }
}
