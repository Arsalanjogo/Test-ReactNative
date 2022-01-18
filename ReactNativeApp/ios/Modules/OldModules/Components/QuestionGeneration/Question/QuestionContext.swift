//
//  QuestionContext.swift
//  jogo
//
//  Created by arham on 21/06/2021.
//

import Foundation

struct QCRenderRet {
  var question: String
  var correctId: Int
  var answers: [String]
}

class QuestionContext {
  var type: QuestionType
  
  public init(qtype: QuestionType) {
    self.type = qtype
  }
  
  public var totalQuestions: [(String, String)] = [(String, String)]()
  public var answerOptions: [[String]] = [[String]]()
  
  public func render(answerCount: Int) -> QCRenderRet {
    let bound: Int = totalQuestions.count
    let questionIndex: Int = Int.random(in: 0..<bound)
    let correctAnswerIndex: Int = Int.random(in: 0..<answerCount)
    
    var answers: [String] = [String]()
    var options: [String] = answerOptions[questionIndex]
    
    let question: String = totalQuestions[questionIndex].0
    let correctAnswer: String = totalQuestions[questionIndex].1
    
    for i in 0..<answerCount {
      if i == correctAnswerIndex { answers.append(correctAnswer)
      } else { answers.append(options.remove(at: Int.random(in: 0..<options.count))) }
    }
    
    return QCRenderRet(question: question, correctId: correctAnswerIndex, answers: answers)
  }
}
