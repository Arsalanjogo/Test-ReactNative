//
//  BallExercise.swift
//  jogo
//
//  Created by arham on 15/03/2021.
//

import Foundation

class BallExercise: BaseExercise {
  // Look into the Person comments. Sames logic but with the Ball Object.
  
  internal final var ball: BallDetection?
  
  override init(calibration: Calibration?, exerciseSettings: OldExerciseSettings) {
    super.init(calibration: calibration, exerciseSettings: exerciseSettings)
    normalInit(ballModelType: .FOOTBALLv16)
  }
  
  init(calibration: Calibration?, exerciseSettings: OldExerciseSettings, ballModelType: ModelManager.MODELTYPE = .FOOTBALLv16) {
    super.init(calibration: calibration, exerciseSettings: exerciseSettings)
    normalInit(ballModelType: .FOOTBALLv16)
  }
  
  init(calibrationImage: String, exerciseSettings: OldExerciseSettings, ballModelType: ModelManager.MODELTYPE = .FOOTBALLv16) {
    super.init(calibration: Calibration(calibrationImage: UIImage(named: calibrationImage)!), exerciseSettings: exerciseSettings)
    normalInit(ballModelType: .FOOTBALLv16)
  }
  
  init(calibrationImage: String, alpha: Double, exerciseSettings: OldExerciseSettings, ballModelType: ModelManager.MODELTYPE = .FOOTBALLv16) {
    super.init(calibration: Calibration(calibrationImage: UIImage(named: calibrationImage)!.withAlpha(alpha: CGFloat(alpha))!),
               exerciseSettings: exerciseSettings)
    normalInit(ballModelType: .FOOTBALLv16)
  }
  
  func normalInit(ballModelType: ModelManager.MODELTYPE = .FOOTBALLv16) {
    ball = BallDetection(modelType: ballModelType, exerciseLead: true, observerId: Football.ObserverID.FOOTBALL.rawValue)
    ball?.setMaxFps(fps: 20)
    objectDetections.append(ball!)
    
    if calibration != nil {
      calibration!.addObjectDetection(objectDetection: ball!)
      // Used the block type NSPredicate expression looked up from https://nshipster.com/nspredicate/
      calibration?.addExtraCheck(predicate: NSPredicate { [unowned self] (evaluatedObject, _) in
        return (evaluatedObject as? DetectionLocation)?.getLabel() ?? "" != self.ball!.label ||
          ((evaluatedObject as? DetectionLocation)?.getRadius() ?? 1.0 < BallDetection.MAX_RADIUS &&
          (evaluatedObject as? DetectionLocation)?.getRadius() ?? 0.0 > BallDetection.MIN_RADIUS)
      })
    }
  }
  
  required init(exerciseSettings: OldExerciseSettings) {
    fatalError("init(viewController:exerciseSettings:) has not been implemented")
  }
  
  override func createAnswerEngine() -> AnswerEngine? {
    return AnswerEngine.builder().circle(radius: 0.1).build()
  }
  
  // MARK: Realtime Graph
  override func populateGraph() {
    graph.point.accept(ball?.getX() ?? 0)
  }
  
}
