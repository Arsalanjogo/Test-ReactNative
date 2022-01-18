//
//  GamePhase.swift
//  jogo
//
//  Created by Mohsin on 13/10/2021.
//

import Foundation

public class GamePhase: Phase {
  
  var points: SSVC<PointsState, SquaredPointsView, PointsController>?
  var timer: SSVC<TimerState, TimerView, TimerController>?
  var ball: BallSSVC<BallState, BallView, BallController>?
  var person: PersonSSVC<PersonState, PersonView, PersonController>?
  
  
  
  public override func process() {
    timer?.controller.process()
    super.process()
  }
  
  /// Provides the functionality of returning the completion of this phase as well as writing down
  /// the value of the complete elapsed time of the game phase.
  public override func isDone() -> Bool {
    let isDone: Bool = timer?.controller.timeFinished() ?? true
    if isDone {
      ExerciseStatsJsonManager.get().fillProperties(completionTime: timer?.controller.getCompletionTime() ?? 0.0)
      ExerciseStatsJsonManager.get().convertAndWriteToFile()
    }
    return isDone
  }
  
  private static var gamePhase: GamePhase?
  
  public static func getPhase() -> GamePhase? {
    return GamePhase.gamePhase
  }
  
  public override func initialize() {
    self.prevPhase = .CalibrationPhase
    self.nextPhase = .EndOfExercisePhase
    points = PointsBuilder.buildSquared()
    timer = TimerBuilder.build()
    person = PersonBuilder.build(state: GameContext.getContext()!.personState!)
    ball = BallBuilder.build(state: GameContext.getContext()!.ballState!)
    person?.changeView(drawType: .SKELETON)
    ball?.changeView(drawType: .CIRCLE)
    GamePhase.gamePhase = self
    super.initialize()
    GameContext.getContext()?.exerciseTime = Date().getMilliseconds()
    
  }
  
  public override func getDebugText() -> String {
    return "\n\n Points:- \n \(points?.getDebugText() ?? "") \n\n Timer:- \n \(timer?.getDebugText() ?? "") \n\n"
  }
  
  public override func cleanup() {
    super.cleanup()
    GameContext.getContext()?.currentScore = self.points?.controller.getPoints() ?? 0
    self.points?.cleanup()
    self.timer?.cleanup()
    self.ball?.cleanup(with: false)
    self.person?.cleanup(with: false)
    self.points = nil
    self.timer = nil
    self.ball = nil
    self.person = nil
  }
}
