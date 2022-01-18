//
//  QuestionScore.swift
//  jogo
//
//  Created by arham on 10/03/2021.
//

import Foundation


class QuestionScore: BaseScore {
  // Displays n questions and increases the score according to the questions answered.
  // Need to add the exercise point system in it too.
  
  var questionCount: Int
  weak var questionManager: QuestionManager?
  
  init(baseExercise: BaseExercise, questionCount: Int) {
    self.questionCount = questionCount
    super.init(exercise: baseExercise)
  }
  
  override func start() {
    super.start()
    startNormalTime()
  }
  
  private func checkQuestions() {
    if questionManager == nil {
      questionManager = baseExercise?.questionManager
    }
    if questionManager!.questionsAnswered() >= questionCount {
      self.stopExercise()
    }
  }
  
  override func addCorrectAnswer() {
    super.addCorrectAnswer()
    exerciseRenderModule?.setProgess(value: Float(questionScore)/Float(questionCount))
    checkQuestions()
  }
  
  override func addWrongAnswer() {
    super.addWrongAnswer()
    checkQuestions()
  }
  
  override func addSkippedAnswer() {
    super.addSkippedAnswer()
    checkQuestions()
  }
}
