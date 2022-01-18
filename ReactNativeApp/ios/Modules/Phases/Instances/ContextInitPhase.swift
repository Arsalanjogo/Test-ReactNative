//
//  ContextInitPhase.swift
//  jogo
//
//  Created by arham on 03/11/2021.
//

import Foundation


class ContextInitPhase: Phase {
  
  var exerciseDefintionParser: ExerciseDefinitionParser!
  var completed: Bool = false
  weak var gamePhaseMod: ContextPhaseDelegate?
  
  init(delegate: GamePhaseDelegate, exercisePhaseMod: ContextPhaseDelegate) {
    self.gamePhaseMod = exercisePhaseMod
    super.init(delegate: delegate, stopRestart: false)
  }
  
  required init(delegate: GamePhaseDelegate, stopRestart: Bool) {
    fatalError("init(delegate:) has not been implemented")
  }
  
  override func process() { }
  
  override func isDone() -> Bool {
    return completed
  }
  
  override func initialize() {
    super.initialize()
    self.phaseName = "ContextInit"
    completed = false
    self.nextPhase = .PromoPhase
    exerciseDefintionParser = ExerciseDefinitionParser(fileName: GameContext.getContext()!.fileName)
    guard let eDefParser: ExerciseDefinitionParser = exerciseDefintionParser else { return }
    guard let eContext: GameContext = GameContext.getContext() else { return }
    eContext.initializeObjectsAndModels(objectsToUse: eDefParser.getObjectsToUse())
    eContext.setGameName(name: eDefParser.getDefinition()?.metadata.gameName)
    self.gamePhaseMod?.insertGamePhase(value: eContext.getGame())
    // Do all of the other initialization in here.
    completed = true
    Profiler.get().profileTime(frameId: GameContext.getContext()?.currentFrameNumber ?? -1, tag: "\(self.phaseName ?? "" )-\(#function)", delta: Date().getMilliseconds() - timings["\(#function)"]!)
  }
  
  override func cleanup() {
    super.cleanup()
    self.gamePhaseMod = nil
    self.exerciseDefintionParser = nil
    Profiler.get().profileTime(frameId: GameContext.getContext()?.currentFrameNumber ?? -1, tag: "\(self.phaseName ?? "" )-\(#function)", delta: Date().getMilliseconds() - timings["\(#function)"]!)
  }
  
  override public func getDebugText() -> String {
    return "Context Init Phase"
  }
  
}
