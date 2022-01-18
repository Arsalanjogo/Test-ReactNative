//
//  Question.swift
//  jogo
//
//  Created by arham on 21/06/2021.
//

import Foundation


class Question: CanDraw {
  
  public final var questionString: String
  private final var answers: [Answer] = [Answer]()
  public var resolved: Bool = false
  public var correct: Bool?
  public let type: QuestionType
  
  let backgroundColor: CGColor
  var textLabel: UILabel?
  var textSize: CGSize?
  var questionColor: CGColor?
  var answered: Bool?
  
  
  public init(question: String, answer: [Answer], type: QuestionType) {
    self.questionString = question
    self.answers = answer
    self.type = type
    self.backgroundColor = UIColor.black.withAlphaComponent(0.35).cgColor
    self.textLabel = nil
    self.questionColor = nil
  }
  
  public func getAnswers() -> [Answer] {
    return answers
  }
  
  public func drawAnswers(canvas: UIView) {
    self.answers.forEach { ans in
      ans.draw(canvas: canvas)
    }
  }
  
  public func resolve(correct: Bool, answered: Bool) {
    self.resolved = true
    self.correct = correct
    self.answered = answered
  }
  
  func processAnswers() -> (Bool, Bool) {
    for ans in self.getAnswers() {
      ans.process()
      if ans.currentlyTouched() {
        _ = self.getAnswers().map({ cans in
          if cans != ans {
            cans.reset()
          }
        })
      }
      
      if ans.canResolve() {
        ans.resolve()
        _ = self.getAnswers().map({ cans in
          if cans != ans {
            cans.resolve()
          }
        })
        
        if ans.correct {
          self.resolve(correct: true, answered: true)
          return (true, true)
        } else {
          self.resolve(correct: false, answered: true)
          return (true, false)
        }
      }
    }
    return (false, false)
  }
  
  func draw(canvas: UIView) {
    switch self.type {
    case .COLOR:
      self.drawColor(canvas: canvas)
    case .PICTURE:
      self.drawText(canvas: canvas)
    case .TEXT:
      self.drawText(canvas: canvas)
    }
    
  }
  
  public static func getLongestString(stringArray: [String]) -> String {
    let str: String = stringArray.max { first, second in
      first.count < second.count
    }!
    return str
  }
  
  public func initializeText(screenWidth: CGFloat, screenHeight: CGFloat) {
    let textColor: UIColor = UIColor(rgb: Int("DBFF00", radix: 16)!)
    let longestQString: String = Question.getLongestString(stringArray: questionString.split(separator: " ").map({ String($0) }))
    
    var fontSize: Int = 24
    if let font = UIFont(name: "BioSans-Bold", size: CGFloat(fontSize)) {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let myText = longestQString
        let size = (myText as NSString).size(withAttributes: fontAttributes)
        let multipliable: Double = Double(screenHeight) / (Double(size.height))
        fontSize = Int(Double(fontSize) * multipliable) / 3
    }
    if let font = UIFont(name: "BioSans-Bold", size: CGFloat(fontSize)) {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let myText = longestQString
        let size = (myText as NSString).size(withAttributes: fontAttributes)
        self.textSize = size
    }
    let uifont: UIFont = UIFont(name: "BioSans-Bold", size: CGFloat(fontSize))!
    textLabel = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenWidth))
    textLabel!.font = uifont
    textLabel!.textAlignment = .center
    textLabel!.backgroundColor = textColor
    
    // More redundancy as usual -_-
    textLabel!.adjustsFontSizeToFitWidth = true
    
  }
  
  func drawText(canvas: UIView) {
    let qString: String = self.questionString.replacingOccurrences(of: " ", with: "\n")
    var fontSize = 25
    var stringSize = qString.size(OfFont: UIFont(name: "BioSans-Bold", size: CGFloat(fontSize))!)
    let screenWidth = canvas.frame.width
    let screenHeight = canvas.frame.height
    while stringSize.width <= (screenWidth - (2 * 0.05 * screenWidth)) - 16 &&
            stringSize.height <= (screenHeight - (2 * 0.05 * screenHeight)) - 16 {
      fontSize += 1
      stringSize = qString.size(OfFont: UIFont(name: "BioSans-Bold", size: CGFloat(fontSize))!)
    }
    let xCord = (canvas.center.x - stringSize.width / 2) / screenWidth
    let yCord = (canvas.center.y - stringSize.height / 2) / screenHeight
    DrawingManager.get().drawText(view: canvas,
                                   origin: CGPoint(x: xCord, y: yCord),
                                   label: qString,
                                   color: ThemeManager.shared.theme.primaryColor,
                                   fontSize: CGFloat(fontSize),
                                   backColor: .black,
                                   fontName: "BioSans-Bold")
  }
  
  func drawColor(canvas: UIView) {
    questionColor = UIColor(rgb: Int(String(questionString.dropFirst()), radix: 16)!).withAlphaComponent(0.40).cgColor
    DrawingManager.get().drawFilledRect(view: canvas,
                                         rect: CGRect(x: 0,
                                                      y: 0,
                                                      width: canvas.frame.width,
                                                      height: canvas.frame.height),
                                         color: questionColor!)
  }
  
  func drawDebug(canvas: UIView) {
    
  }
  
  public func toMap() -> [String: Any] {
    return [String: Any]()
  }
  
  public func getQuestionJson() -> QuestionJson {
    var answerJson: [AnswerJson] = [AnswerJson]()
    answers.forEach { answer in
      answerJson.append(answer.getAnswerJson())
    }
    let qJson = QuestionJson(question: self.questionString,
                             resolved: self.resolved,
                             answered: self.answered ?? false,
                             correct: self.correct ?? false,
                             answers: answerJson)
    return qJson
  }
}
