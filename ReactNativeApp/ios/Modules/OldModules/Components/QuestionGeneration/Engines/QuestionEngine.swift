//
//  QuestionEngine.swift
//  jogo
//
//  Created by arham on 21/06/2021.
//

import Foundation

public enum QuestionType: String {
  case COLOR = "Color"
  case PICTURE = "Picture"
  case TEXT = "Text"
}

class QuestionEngine {
  
  final var qContext: QuestionContext
  final var aEngine: AnswerEngine
  final var answerCount: Int
  
  public init(context: QuestionContext, answerEngine: AnswerEngine, ansCount: Int) {
    self.qContext = context
    self.aEngine = answerEngine
    self.answerCount = ansCount
  }
  
  public func render() -> Question {
    let context: QCRenderRet = qContext.render(answerCount: answerCount)
    var answers: [Answer] = [Answer]()
  
    for i in 0...answerCount - 1 {
      answers.append(aEngine.instantiate(index: i, correct: i == context.correctId, answer: context.answers[i], type: qContext.type))
    }
    return Question(question: context.question, answer: answers, type: qContext.type)
  }
  
  public static func builder() -> QuestionBuilder {
    return QuestionBuilder()
  }
}
