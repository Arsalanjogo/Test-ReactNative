//
//  Answer.swift
//  jogo
//
//  Created by arham on 21/06/2021.
//

import Foundation

class Answer: MovingLocation {
  
  final var answerString: String
  final var correct: Bool
  final var type: QuestionType
  final var answerMovement: AnswerMovement?
  final var answerBehavior: AnswerBehavior
  internal var resolved: Bool = false
  internal var selected: Bool = false
  
  internal var resolutionAmount: Int = 2
  internal var resolutionTime: Double?
  
  internal var touchedCounter: Int = 0
  internal var answerTime: Double
  internal var startTime: Double?
  
  internal var drawResolutionTime: Double?
  
  var drawable: UIImage?
  
  init(answerStr: String,
       correct: Bool,
       x: Double,
       y: Double,
       answerMove: AnswerMovement?,
       answerBehave: AnswerBehavior,
       type: QuestionType) {
    self.answerString = answerStr
    self.correct = correct
    self.type = type
    self.answerMovement = answerMove
    self.answerBehavior = answerBehave
    self.type = type
    self.answerTime = 2000
    super.init(x: x, y: y)
  }
  
  required init(from decoder: Decoder) throws {
    fatalError("init(from:) has not been implemented")
  }
  
  public func start() {
    self.startTime = Date().getMilliseconds()
  }
  
  public func process() {
    if answerBehavior.touched(answer: self) {
      touchedCounter += 1
    }
    if (answerMovement != nil) {
      var loc: (Double, Double) = answerMovement?.update(x: self.getX(), y: self.getY()) ?? (0, 0)
      self.setX(value: loc.0)
      self.setY(value: loc.1)
    }
  }
  
  public func canResolve() -> Bool {
    return touchedCounter == resolutionAmount
  }
  
  public func resolve() {
    resolutionTime = Date().getMilliseconds()
    resolved = true
    if touchedCounter != resolutionAmount {
      selected = false
      return
    }
    selected = true
    if correct {
      answerBehavior.onSuccess()
    } else {
      answerBehavior.onFailure()
    }
  }
  
  public func reset() {
    touchedCounter = 0
  }
  
  internal func touched(detectionLocation: DetectionLocation) -> Bool { return false }
  
  public func currentlyTouched() -> Bool {
    return touchedCounter > 0
  }
  
  override func draw(canvas: UIView) {
    switch type {
    case .COLOR:
      self.drawColor(canvas: canvas)
    case .TEXT:
      self.drawText(canvas: canvas)
    case .PICTURE:
      self.drawImage(canvas: canvas)
    }
    if selected {
      drawSelected(canvas: canvas)
    }
  }
  
  public func drawSelected(canvas: UIView) {}
  
  public func drawText(canvas: UIView) {}
  
  public func drawColor(canvas: UIView) {}
  
  public func drawImage(canvas: UIView) {}
  
  public func preLoadPicture(name: String) {
    self.drawable = UIImage(named: name)
  }
  
  public func percentageOfFinalDraw() -> Double {
    let per: Double = (Date().getMilliseconds() - startTime!) / answerTime
    return per
  }
  
  public func setDrawResolutionTime(drawResolutionTime: Double) {
    self.drawResolutionTime = drawResolutionTime
  }
  
  public func setAnswerTime(answerTime: Double) {
    self.answerTime = answerTime
  }
  
  // This function is kinda useless innit?
  public func toMap() -> [String: Any] {
    return ["answer": self.answerString, "selected": self.selected, "answerTime": self.answerTime]
  }
  
  public func getAnswerJson() -> AnswerJson {
    return AnswerJson(answer: self.answerString, selected: self.selected, answerTime: self.answerTime)
  }
}
