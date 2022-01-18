//
//  AnswerBuilderUtil.swift
//  jogo
//
//  Created by arham on 21/06/2021.
//

import Foundation

internal typealias AnswerBuilderAlias = (String,
                                         Bool,
                                         Double,
                                         Double,
                                         AnswerMovement?,
                                         AnswerBehavior,
                                         QuestionType) -> Answer

internal protocol AnswerBuilderProtocol {
  
  func render(answer: String,
              correct: Bool,
              x: Double,
              y: Double,
              answerMovement: AnswerMovement?,
              answerBehavior: AnswerBehavior,
              type: QuestionType) -> Answer
  func renderCircle(answer: String,
                    correct: Bool,
                    x: Double,
                    y: Double,
                    answerMovement: AnswerMovement?,
                    answerBehavior: AnswerBehavior,
                    type: QuestionType) -> CircleAnswer
}
