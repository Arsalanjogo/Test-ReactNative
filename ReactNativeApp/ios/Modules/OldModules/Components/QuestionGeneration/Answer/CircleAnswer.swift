//
//  CircleAnswer.swift
//  jogo
//
//  Created by arham on 21/06/2021.
//

import Foundation


class CircleAnswer: Answer {
  
  var radius: Double
  var image: UIImage?
  
  public init(answer: String, correct: Bool, x: Double, y: Double, raduis: Double, answerMovement: AnswerMovement?, answerBehavior: AnswerBehavior, type: QuestionType) {
    self.radius = raduis
    if type == .PICTURE {
      image = UIImage(named: answer)
    }
    super.init(answerStr: answer, correct: correct, x: x, y: y, answerMove: answerMovement, answerBehave: answerBehavior, type: type)
  }
  
  required init(from decoder: Decoder) throws {
    fatalError("init(from:) has not been implemented")
  }
  
  override func getRadius() -> Double {
    return self.radius
  }
  
  override func touched(detectionLocation: DetectionLocation) -> Bool {
    return checkIntersection(location: detectionLocation)
  }
  
  override func drawText(canvas: UIView) {
    let centerX: CGFloat = self.canvasX(canvas: canvas)
    let centerY: CGFloat = self.canvasY(canvas: canvas)
    let canvasRad: CGFloat = self.canvasRadius(canvas: canvas)
    
    var fontSize = 12
    var stringSize = self.answerString.size(OfFont: UIFont(name: "BioSans-Bold", size: CGFloat(fontSize))!)
    while stringSize.width <= canvasRad {
      fontSize += 1
      stringSize = self.answerString.size(OfFont: UIFont(name: "BioSans-Bold", size: CGFloat(fontSize))!)
    }
    let xCord = (centerX - (stringSize.width / 2)) / canvas.frame.width
    let yCord = (centerY - (stringSize.height / 2)) / canvas.frame.height
    
    DrawingManager.get().drawCircle(view: canvas, center: CGPoint(x: self.getX(), y: self.getY()), with: canvasRad, color: UIColor.black.withAlphaComponent(0.7))
    DrawingManager.get().drawText(view: canvas,
                                   origin: CGPoint(x: xCord, y: yCord),
                                   label: self.answerString,
                                   color: .white,
                                   fontSize: CGFloat(fontSize),
                                   fontName: "BioSans-Bold")
    self.drawArc(canvas: canvas, centerX: CGFloat(getX()), centerY: CGFloat(getY()), width: canvasRad)
  }
  
  override func drawColor(canvas: UIView) {
    let canvasRad: CGFloat = self.canvasRadius(canvas: canvas)
    DrawingManager.get().drawCircle(view: canvas, center: CGPoint(x: self.getX(), y: self.getY()), with: canvasRad, color: UIColor(rgb: Int(String(answerString.dropFirst()), radix: 16)!))
    self.drawArc(canvas: canvas, centerX: CGFloat(self.getX()), centerY: CGFloat(self.getY()), width: canvasRad)
  }
  
  override func drawImage(canvas: UIView) {
    let centerX: CGFloat = self.canvasX(canvas: canvas)
    let centerY: CGFloat = self.canvasY(canvas: canvas)
    let canvasRad: CGFloat = self.canvasRadius(canvas: canvas)
    DrawingManager.get().drawImage(view: canvas, image: image, x: centerX, y: centerY, rad: canvasRad)
    self.drawArc(canvas: canvas, centerX: CGFloat(self.getX()), centerY: CGFloat(self.getY()), width: canvasRad)
  }
  
  override func drawSelected(canvas: UIView) {
    let canvasRad: CGFloat = self.canvasRadius(canvas: canvas)
    let maxSize: CGFloat = max(canvas.frame.height, canvas.frame.width)
    let percentage: Double = (Date().getMilliseconds() - resolutionTime!) / drawResolutionTime!
    let redDim: CGFloat = canvasRad + (maxSize * CGFloat(percentage))
    DrawingManager.get().drawCircle(view: canvas,
                                     center: CGPoint(x: self.getX(), y: self.getY()),
                                     with: redDim,
                                     color: correct ? UIColor(rgb: Int("DBFF00", radix: 16)!).withAlphaComponent(0.4) : UIColor.red.withAlphaComponent(0.4))
    DrawingManager.get().drawCircle(view: canvas, center: CGPoint(x: self.getX(), y: self.getY()), with: canvasRad, color: UIColor.black.withAlphaComponent(0))
  }
  
  func drawArc(canvas: UIView, centerX: CGFloat, centerY: CGFloat, width: CGFloat) {
    if !resolved {
      let endAngle: CGFloat = CGFloat(max(1 - percentageOfFinalDraw(), 0)) * 360
      DrawingManager.get().drawArc(view: canvas, center: CGPoint(x: centerX, y: centerY), radius: width, sweepAngle: endAngle)
    }
  }
  
}
