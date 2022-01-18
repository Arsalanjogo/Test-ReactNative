//
//  AnswerBuilder.swift
//  jogo
//
//  Created by arham on 22/06/2021.
//

import Foundation


class AnswerBuilder: AnswerBuilderProtocol {
  
  private var answerMovement: AnswerMovement?
  private var questionLocation: QuestionLocation?
  private var answerBehavior: AnswerBehavior = AnswerBehavior()
  var answerBuilder: AnswerBuilderAlias?
  static private var radius: Double = 0.13

  
  static private func getRadius() -> Double {
    return AnswerBuilder.radius
  }
  
  public init() {
  }
  
  deinit {
    print("Destroyed!!!")
  }
  
  public func circle(radius: Double) -> AnswerBuilder {
    AnswerBuilder.radius = radius
    self.answerBuilder = renderCircle(answer:correct:x:y:answerMovement:answerBehavior:type:)
    return self
  }
  
  func render(answer: String,
              correct: Bool,
              x: Double,
              y: Double,
              answerMovement: AnswerMovement?,
              answerBehavior: AnswerBehavior,
              type: QuestionType) -> Answer {
    return Answer(answerStr: answer, correct: correct, x: x, y: y, answerMove: answerMovement!, answerBehave: answerBehavior, type: type)
  }
  
  func renderCircle(answer: String,
                    correct: Bool,
                    x: Double,
                    y: Double,
                    answerMovement: AnswerMovement?,
                    answerBehavior: AnswerBehavior,
                    type: QuestionType) -> CircleAnswer {
    return CircleAnswer(answer: answer, correct: correct, x: x, y: y, raduis: AnswerBuilder.radius, answerMovement: answerMovement, answerBehavior: answerBehavior, type: type)
  }
  
  func initLocation(questionLocation: @escaping QuestionLocation) -> AnswerBuilder {
    self.questionLocation = questionLocation
    return self
  }
  
  func initPersonCenterPoint(person: PersonDetection?) -> AnswerBuilder {
    self.questionLocation = {
      if person?.isPersonLayingDown() ?? false {
        return AnswerBuilder.initPersonCenterPointLyingDown(person: person, questionId: $0 )
      } else {
        return AnswerBuilder.initPersonCenterPointStanding(person: person, questionId: $0 )
      }
    }
    return self
  }
  
  static func initPersonCenterPointLyingDown(person: PersonDetection?, questionId: Int?) -> (Double, Double) {
    if questionId == nil {
      return (0, 0)
    }
    let lyingDirection: PersonDetection.LyingDirection = person?.getPersonLyingDirection() ?? .LEFT2RIGHT
    let facingDirection: PersonDetection.LyingDownFacingDirection = person?.getPersonLyingDownFacingDirection() ?? .UP
    
    let armLength: Double = (person?.getPersonArmLength() ?? 0.25) * 1.3
    
    let centerPoint: DetectionLocation? = (person?.leftArm?.shoulder.getY() ?? 0) < (person?.rightArm?.shoulder.getY() ?? 0) ?
      person?.leftArm?.shoulder.getLocation() :
      person?.rightArm?.shoulder.getLocation()
    
    
    // Logic starts here
    let endPoints: Bool = questionId! == 0 || questionId! == 3
    let i: Double = Double(questionId!) / 3
    let angle: Double = (90 - (89 * i)) * (2 * Double.pi / 360) // Converted to radians
    let heigthAdditionScale: Double = ((armLength * sin(angle)) / sin(Double.pi * 0.5) / armLength) * (facingDirection == .UP ? 1: -1)
    let widthAdditionScale: Double = ((armLength * sin((Double.pi * 0.5) - angle)) / sin(Double.pi * 0.5) / (armLength * 1.4)) * (facingDirection == .UP ? 1: -1)
    
    var xCenter: Double
    var yCenter: Double
    let gRadius: Double = AnswerBuilder.getRadius()
    let xTranslate: Double = i == 0 ?
      -gRadius * (facingDirection == .UP ? 1: -1) :
      (-gRadius * 0.5) * (facingDirection == .UP ? 1: -1)
    
    let distance: Double = gRadius + armLength
    var yInside: Double = (centerPoint?.getY() ?? 0) - (distance * heigthAdditionScale)
    yInside = endPoints ? yInside + gRadius: yInside
    yCenter = MathUtil.clip(inside: yInside, rad: gRadius)
    
    switch lyingDirection {
    case .LEFT2RIGHT:
      let xInside: Double = (centerPoint?.getX() ?? 0) + (distance * widthAdditionScale) + xTranslate
      xCenter = MathUtil.clip(inside: xInside, rad: gRadius)
    case .RIGHT2LEFT:
      let xInside: Double = (centerPoint?.getX() ?? 1) - (distance * widthAdditionScale) - xTranslate
      xCenter = MathUtil.clip(inside: xInside, rad: gRadius)
    }    
    return (xCenter, yCenter)
  }
  
  static func initPersonCenterPointStanding(person: PersonDetection?, questionId: Int?) -> (Double, Double) {
    if questionId == nil {
       return (0, 0)
    }
    let left: Bool = questionId! % 2 == 0
    let top: Bool = questionId! < 2
    let center: (Double, Double) = person?.getCenterPoint() ?? (0, 0)
    
    var xCenter: Double
    let width: Double = (person?.hipToHip?.getFullLength() ?? 0) / 0.8
    let gRadius: Double = AnswerBuilder.getRadius()
    if top {
      let inside: Double = left ? center.0 - width - gRadius : center.0 + width + gRadius
      xCenter = MathUtil.clip(inside: inside, rad: gRadius)
    } else {
      if person == nil { return (0, 0) }
      let leftShoulder = person!.leftArm!.shoulder.getX() ?? 0
      let rightShoulder = person!.rightArm!.shoulder.getX() ?? 0
      let inside: Double = left ? leftShoulder - width - gRadius : rightShoulder + width + gRadius
      xCenter = MathUtil.clip(inside: inside, rad: gRadius)
      xCenter = left ? xCenter - (width * 1.1) : xCenter + (width * 1.1)
    }
    
    let shoulderY: Double = MathUtil.getMean(a: person!.leftArm!.shoulder, b: person!.rightArm!.shoulder, axis: .y)
    let distY: Double = center.1 - shoulderY
    let yCenter: Double = MathUtil.clip(inside: top ? shoulderY - distY / 2 - gRadius : shoulderY + distY / 5.5 + gRadius, rad: gRadius)
    return (xCenter, yCenter)
  }
  
  func build() -> AnswerEngine? {
    let aEngine = AnswerEngine(qLoc: self.questionLocation!, aMove: self.answerMovement, aBuild: self.answerBuilder!, aBehave: self.answerBehavior)
    self.questionLocation = nil
    self.answerBuilder = nil
    self.answerMovement = nil
    return aEngine
  }
  
  func anyMatch(match: ObjectDetection...) -> AnswerBuilder {
    match.forEach { [weak self] objDet in
      self?.answerBehavior.addAnyMatch(objDet: objDet)
    }
    return self
  }
  
  func allMatch(match: ObjectDetection...) -> AnswerBuilder {
    match.forEach { [weak self] objDet in
      self?.answerBehavior.addAllMatch(objDet: objDet)
    }
    return self
  }
  
  func customMovement(ansMove: AnswerMovement) -> AnswerBuilder {
    self.answerMovement = ansMove
    return self
  }
  
  func onSuccess(noArgsMethod: @escaping () -> Void) -> AnswerBuilder {
    self.answerBehavior.addOnSuccess(method: noArgsMethod)
    return self
  }
  
  func onFailure(noArgsMethod: @escaping () -> Void) -> AnswerBuilder {
    self.answerBehavior.addOnFailure(method: noArgsMethod)
    return self
  }
}
