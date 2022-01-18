//
//  BallPersonExercise.swift
//  jogo
//
//  Created by arham on 15/03/2021.
//

import Foundation

class BallPersonExercise: BaseExercise {
  // Initialize the Ball and Person object and calibration class.
  // Add both specific ball and person related unique predicates
  // into calibration.
  
  internal final var person: PersonDetection?
  internal final var ball: BallDetection?
  
  // Ball shouldn't be too big. 25% of the smaller dimension.
  internal var MAX_BALL_RADIUS: Double = 0.25

  override init(calibration: Calibration?,
                exerciseSettings: OldExerciseSettings) {
    super.init(calibration: calibration, exerciseSettings: exerciseSettings)
    normalInit(personModelType: .POSENET, ballModelType: .FOOTBALLv16, upperBody: true, lowerBody: true)
  }
  
  init(calibration: Calibration?,
       exerciseSettings: OldExerciseSettings,
       personModelType: ModelManager.MODELTYPE,
       ballModelType: ModelManager.MODELTYPE,
       upperBody: Bool = true,
       lowerBody: Bool = true) {
    super.init(calibration: calibration, exerciseSettings: exerciseSettings)
    normalInit(personModelType: personModelType, ballModelType: ballModelType, upperBody: upperBody, lowerBody: lowerBody)
  }
  
  init(calibrationImage: String,
       exerciseSettings: OldExerciseSettings,
       personModelType: ModelManager.MODELTYPE = .POSENET,
       ballModelType: ModelManager.MODELTYPE = .FOOTBALLv16,
       upperBody: Bool = true,
       lowerBody: Bool = true) {
    super.init(calibration: Calibration(calibrationImage: UIImage(named: calibrationImage)!), exerciseSettings: exerciseSettings)
    normalInit(personModelType: personModelType, ballModelType: ballModelType, upperBody: upperBody, lowerBody: lowerBody)
  }
  
  init(calibrationAsset: LottieMapping.LottieExercise,
       exerciseSettings: OldExerciseSettings,
       personModelType: ModelManager.MODELTYPE = .POSENET,
       ballModelType: ModelManager.MODELTYPE = .FOOTBALLv16,
       upperBody: Bool = true,
       lowerBody: Bool = true) {
    super.init(calibration: Calibration(calibrationAsset: calibrationAsset), exerciseSettings: exerciseSettings)
    normalInit(personModelType: personModelType, ballModelType: ballModelType, upperBody: upperBody, lowerBody: lowerBody)
  }

  init(calibrationImage: String,
       alpha: Double,
       exerciseSettings: OldExerciseSettings,
       personModelType: ModelManager.MODELTYPE = .POSENET,
       ballModelType: ModelManager.MODELTYPE = .FOOTBALLv16,
       upperBody: Bool = true,
       lowerBody: Bool = true) {
    super.init(calibration: Calibration(calibrationImage: UIImage(named: calibrationImage)!.withAlpha(alpha: CGFloat(alpha))!),
               exerciseSettings: exerciseSettings)
    normalInit(personModelType: personModelType, ballModelType: ballModelType, upperBody: upperBody, lowerBody: lowerBody)
  }
  
  func normalInit(personModelType: ModelManager.MODELTYPE = .POSENET,
                  ballModelType: ModelManager.MODELTYPE = .FOOTBALLv16,
                  upperBody: Bool = true,
                  lowerBody: Bool = true) {
    person = PersonDetection(exerciseLead: false, modelType: personModelType, upperBody: upperBody, lowerBody: lowerBody)
    ball = BallDetection(modelType: ballModelType, exerciseLead: true, observerId: Football.ObserverID.FOOTBALL.rawValue)
    person?.setMaxFps(fps: 15)
    ball?.setMaxFps(fps: 18)
    objectDetections.append(person!)
    objectDetections.append(ball!)
    
    if calibration != nil {
      calibration?.addObjectDetection(objectDetection: ball!)
      calibration?.addExtraCheck(predicate: NSPredicate { [unowned self] (evaluatedObject, _) in
        return (evaluatedObject as? DetectionLocation)?.getLabel() ?? "" != self.ball!.label ||
          (evaluatedObject as? DetectionLocation)?.getRadius() ?? 1.0 < self.MAX_BALL_RADIUS
      })
      person!.getDetectionSubClasses().forEach { (objDet) in
        calibration?.addObjectDetection(objectDetection: objDet)
      }
    }
  }
  
  required init(exerciseSettings: OldExerciseSettings) {
    fatalError("init(viewController:exerciseSettings:) has not been implemented")
  }
  
  override func drawBoundingBox(canvas: UIView) {
    person?.drawBBox(canvas: canvas)
  }
  
  override func createAnswerEngine() -> AnswerEngine? {
    return AnswerEngine.builder()
      .circle(radius: 0.1)
      .initPersonCenterPoint(person: self.person)
      .anyMatch(match: self.person!.leftArm!.wrist)
      .anyMatch(match: self.person!.leftArm!.index)
      .anyMatch(match: self.person!.rightArm!.wrist)
      .anyMatch(match: self.person!.rightArm!.index)
      .build()
  }

  
  
  //MARK: Realtime Graph
  override func populateGraph() {
    graph.point.accept(ball?.getX() ?? 0)
  }
}
