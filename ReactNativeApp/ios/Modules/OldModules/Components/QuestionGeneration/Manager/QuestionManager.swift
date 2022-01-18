//
//  QuestionManager.swift
//  jogo
//
//  Created by arham on 21/06/2021.
//

import Foundation

class QuestionManager: CanDraw, QuestionManagerProtocol {
  
  internal final var timer: TimerUtil?
  internal final weak var score: BaseScore?
  
  private final var questions: [Question?] = [Question?]()
  
  private var qPMediator: QuestionPhaseMediator?
  var qEngine: QuestionEngine
  var currentQuestion: Question?
  
  var running: Bool = false
  var task: Timer?
  
  init(score: BaseScore, qEngine: QuestionEngine, timer: TimerUtil) {
    self.score = score
    self.timer = timer
    self.qEngine = qEngine
    self.initQuestionPhaseManager()
  }
  
  func initQuestionPhaseManager() {
    self.qPMediator = QuestionPhaseMediator(drawQuestion: self.drawQuestions,
                                            drawAnswers: self.drawAnswers,
                                            initQuestions: self.initQuestion,
                                            cleanQuestions: self.cleanQuestion,
                                            initAnswerPhase: self.initAnswerPhase,
                                            processAnswers: self.processAnswers,
                                            checkAnswerSkipped: self.checkAnswerSkipped)
  }
  
  func start() {
    if running { return }
    running = true
    do {
      task = try timer?.scheduleInfinite(runnable: { [weak self] in
                                          self?.process() },
                                         delay: 30,
                                         repeats: true)
    } catch {
      Logger.shared.logError(logType: .ERROR, error: error)
    }
    qPMediator?.start(phaseValue: .COOLDOWN)
  }
  
  func pause() { }
  
  func stop() {
    if !running { return }
    running = false
    task?.invalidate()
  }
  
  func process() {
    if !running { return }
    qPMediator?.process()
  }
  
  func initQuestion() {
    currentQuestion = qEngine.render()
    currentQuestion?.getAnswers().forEach({ ans in
      ans.setDrawResolutionTime(drawResolutionTime: QuestionPhaseMediator.answerResolutionPhaseTime)
      ans.setAnswerTime(answerTime: QuestionPhaseMediator.answerPhaseTime)
    })
  }
  
  func initAnswerPhase() {
    currentQuestion?.getAnswers().forEach({ ans in
      ans.start()
    })
  }
  
  func processAnswers() {
    let res: (Bool, Bool) = currentQuestion!.processAnswers()
    if !res.0 { return }
    questions.append(currentQuestion)
    if res.1 {
      score?.addCorrectAnswer()
    } else {
      score?.addWrongAnswer()
    }
    self.qPMediator?.start(phaseValue: .ANSWERRESOLUTION)
  }
  
  func checkAnswerSkipped() {
    if !currentQuestion!.resolved {
      questions.append(currentQuestion)
      currentQuestion?.resolve(correct: false, answered: false)
      score?.addSkippedAnswer()
      currentQuestion = nil
    }
  }
  
  func cleanQuestion() {
    currentQuestion = nil
  }
  
  func questionsAnswered() -> Int {
    return questions.count
  }
  
  func getCurrentQuestion() -> Question? {
    return currentQuestion
  }
  
  func drawQuestions(canvas: UIView) {
    currentQuestion?.draw(canvas: canvas)
  }
  
  func drawAnswers(canvas: UIView) {
    currentQuestion?.drawAnswers(canvas: canvas)
  }
  
  func draw(canvas: UIView) {
    self.qPMediator?.draw(canvas: canvas)
  }
  
  func drawDebug(canvas: UIView) {
    self.qPMediator?.drawDebug(canvas: canvas)
  }
  
  func end() {
    self.qPMediator?.stop()
    self.stop()
    self.qPMediator = nil
  }
}
