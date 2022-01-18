//
//  QuestionPhaseMediator.swift
//  jogo
//
//  Created by arham on 25/06/2021.
//

import Foundation


class QuestionPhaseMediator {
  
  typealias NoArgsMethod = () -> Void
  typealias CanvasMethod = (UIView) -> Void
  
  enum PhasesEnum {
    case COOLDOWN
    case QUESTION
    case ANSWER
    case ANSWERRESOLUTION
  }
  
  public static var cooldownPhaseTime: Double = 1500
  public static var questionPhaseTime: Double = 800
  public static var answerPhaseTime: Double = 2000
  public static var answerResolutionPhaseTime: Double = 200
  
  internal var phaseManager: QuestionPhaseManager? = QuestionPhaseManager()
  internal var cooldownPhase: PhaseA?
  internal var questionPhase: PhaseA?
  internal var answerResolutionPhase: PhaseA?
  internal var answerPhase: PhaseA?
  
  internal var drawQuestion: CanvasMethod?
  internal var drawAnswers: CanvasMethod?
  
  internal var initQuestions: NoArgsMethod?
  internal var cleanQuestions: NoArgsMethod?
  internal var initAnswerPhase: NoArgsMethod?
  internal var processAnswers: NoArgsMethod?
  internal var checkAnswerSkipped: NoArgsMethod?
  
  init(drawQuestion: @escaping CanvasMethod,
       drawAnswers: @escaping CanvasMethod,
       initQuestions: @escaping NoArgsMethod,
       cleanQuestions: @escaping NoArgsMethod,
       initAnswerPhase: @escaping NoArgsMethod,
       processAnswers: @escaping NoArgsMethod,
       checkAnswerSkipped: @escaping NoArgsMethod) {
    self.drawQuestion = drawQuestion
    self.drawAnswers = drawAnswers
    self.initQuestions = initQuestions
    self.cleanQuestions = cleanQuestions
    self.initAnswerPhase = initAnswerPhase
    self.processAnswers = processAnswers
    self.checkAnswerSkipped = checkAnswerSkipped
    cooldownPhase = PhaseA(draw: nil, drawDebug: nil, phaseTime: QuestionPhaseMediator.cooldownPhaseTime)
    questionPhase = PhaseA(draw: self.drawQuestion, drawDebug: nil, phaseTime: QuestionPhaseMediator.questionPhaseTime)
      .onStart { [weak self] in
        self?.initQuestions!()
      }
    answerResolutionPhase = PhaseA(draw: self.drawAnswers, drawDebug: nil, phaseTime: QuestionPhaseMediator.answerResolutionPhaseTime)
      .onEnd { [weak self] in
        self?.cleanQuestions!()
      }
    answerPhase = PhaseA(draw: self.drawAnswers, drawDebug: nil, phaseTime: QuestionPhaseMediator.answerPhaseTime)
      .onStart { [weak self] in
        self?.initAnswerPhase!()
      }
      .onProcess { [weak self] in
        self?.processAnswers!()
      }
      .onEnd { [weak self] in
        self?.checkAnswerSkipped!()
      }
    self.initializePhases()
  }
  
  private func initializePhases() {
    _ = phaseManager?
      .map(from: cooldownPhase!, to: questionPhase!)
      .map(from: questionPhase!, to: answerPhase!)
      .map(from: answerPhase!, to: cooldownPhase!)
    
    _ = phaseManager?.map(from: answerResolutionPhase!, to: cooldownPhase!)
  }
  
  func start(phaseValue: PhasesEnum) {
    switch phaseValue {
    case .COOLDOWN:
      phaseManager?.start(phase: cooldownPhase!)
    case .ANSWER:
      phaseManager?.start(phase: answerPhase!)
    case .ANSWERRESOLUTION:
      phaseManager?.start(phase: answerResolutionPhase!)
    case .QUESTION:
      phaseManager?.start(phase: questionPhase!)
    }
  }
  
  func process() {
    self.phaseManager?.process()
  }
  
  func draw(canvas: UIView) {
    self.phaseManager?.draw(canvas: canvas)
  }
  
  func drawDebug(canvas: UIView) {
    self.phaseManager?.drawDebug(canvas: canvas)
  }
  
  func stop() {
    self.phaseManager?.stop()
    self.phaseManager = nil
    self.initQuestions = nil
    self.cleanQuestions = nil
    self.initAnswerPhase = nil
    self.processAnswers = nil
    self.checkAnswerSkipped = nil
    self.drawQuestion = nil
    self.drawAnswers = nil
    
  }
  
}
