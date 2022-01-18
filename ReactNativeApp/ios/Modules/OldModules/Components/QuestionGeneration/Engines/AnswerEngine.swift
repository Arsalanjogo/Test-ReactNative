//
//  AnswerEngine.swift
//  jogo
//
//  Created by arham on 21/06/2021.
//

import Foundation

class AnswerEngine {
  
  final var qLocation: QuestionLocation?
  final var answerMovement: AnswerMovement?
  final var answerBuilder: AnswerBuilderAlias!
  final var answerBehavior: AnswerBehavior?
  
  public init(qLoc: QuestionLocation?, aMove: AnswerMovement?, aBuild: @escaping AnswerBuilderAlias, aBehave: AnswerBehavior?) {
    self.qLocation = qLoc
    self.answerMovement = aMove
    self.answerBuilder = aBuild
    self.answerBehavior = aBehave
  }
  
  public func instantiate(index: Int, correct: Bool, answer: String, type: QuestionType) -> Answer {
    let location: (Double, Double) = self.qLocation!(index)
    return self.answerBuilder(answer, correct, location.0, location.1, self.answerMovement, self.answerBehavior!, type)
  }
  
  public static func builder() -> AnswerBuilder {
    return AnswerBuilder()
  }
}
