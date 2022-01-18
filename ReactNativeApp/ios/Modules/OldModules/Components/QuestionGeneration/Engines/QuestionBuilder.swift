//
//  QuestionBuilder.swift
//  jogo
//
//  Created by arham on 24/06/2021.
//

import Foundation


class QuestionBuilder {
  var questionPath: String = "colorQuestions"
  var qContext: QuestionContext?
  var answerEngine: AnswerEngine?
  var answerCount: Int = 4
  
  public init() {
//    self.colors(questionPath: self.questionPath)
  }
  
  public func colors(questionPath: String) {
    self.initializeQContext(filename: questionPath, type: .COLOR)
  }
  
  public func text(questionPath: String) {
    self.initializeQContext(filename: questionPath, type: .TEXT)
  }
  
  public func picture(questionPath: String) {
    self.initializeQContext(filename: questionPath, type: .PICTURE)
  }
  
  public func initializeQContext(filename: String, type: QuestionType) {
    let ejRep: ExerciseJsonRepresentation? = self.loadJson(fileName: filename)
    qContext = QuestionContext(qtype: type)
    
    var questionPairs: [(String, String)] = [(String, String)]()
    var answerOptions: [[String]] = [[String]]()
    
    ejRep?.questions.forEach({ qjR in
      questionPairs.append((qjR.question, qjR.answer))
      answerOptions.append([qjR.A, qjR.B, qjR.C])
    })
    qContext?.totalQuestions = questionPairs
    qContext?.answerOptions = answerOptions
  }
  
  public func loadJson(fileName: String) -> ExerciseJsonRepresentation? {
     let decoder = JSONDecoder()
     guard
          let url = Bundle.main.url(forResource: fileName, withExtension: "json"),
          let data = try? Data(contentsOf: url),
          let exercisej = try? decoder.decode(ExerciseJsonRepresentation.self, from: data)
     else {
          return nil
     }

     return exercisej
  }
  
  public func setContext(context: QuestionContext) -> QuestionBuilder {
    self.qContext = context
    return self
  }
  
  public func setAnswerEngine(ansEngine: AnswerEngine) -> QuestionBuilder {
    self.answerEngine = ansEngine
    return self
  }
  
  public func build() -> QuestionEngine? {
    if self.qContext == nil {
      return nil
    }
    if self.answerEngine == nil {
      return nil
    }
    return QuestionEngine(context: self.qContext!, answerEngine: self.answerEngine!, ansCount: self.answerCount)
  }
  
  public func setAnswerCount(answerCount: Int) -> QuestionBuilder {
    self.answerCount = max(1, answerCount)
    return self
  }
}
