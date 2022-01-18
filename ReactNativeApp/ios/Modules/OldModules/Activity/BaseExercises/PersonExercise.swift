//
//  PersonExercise.swift
//  jogo
//
//  Created by arham on 15/03/2021.
//

import Foundation

class PersonExercise: BaseExercise {
  // Adds a Person OR in the exercise so that the model associated with the Person will be initialized when the first OR related
  // to the model is initialized.
  
  internal final var person: PersonDetection?
  
  var graphValue: Double = 0
  
  
  // Old init method with the complete calibration initializer in the exercise passed over here.
  override init(calibration: Calibration?, exerciseSettings: OldExerciseSettings) {
    super.init(calibration: calibration, exerciseSettings: exerciseSettings)
    self.normalInit()
  }
  
  // Old init but with added default optional parameters.
  init(calibration: Calibration?,
       exerciseSettings: OldExerciseSettings,
       personModelType: ModelManager.MODELTYPE = .POSENET,
       upperBody: Bool = true,
       lowerBody: Bool = true) {
    super.init(calibration: calibration, exerciseSettings: exerciseSettings)
    normalInit(modelType: personModelType, upperBody: upperBody, lowerBody: lowerBody)
  }
  
  // New initializer. Takes name of calibration image instead.
  init(calibrationImageName: String,
       exerciseSettings: OldExerciseSettings,
       personModelType: ModelManager.MODELTYPE = .POSENET,
       upperBody: Bool = true,
       lowerBody: Bool = true) {
    super.init(calibration: Calibration(calibrationImage: UIImage(named: calibrationImageName)!), exerciseSettings: exerciseSettings)
    normalInit(modelType: personModelType, upperBody: upperBody, lowerBody: lowerBody)
  }
  
  init(calibrationAsset: LottieMapping.LottieExercise,
       exerciseSettings: OldExerciseSettings,
       personModelType: ModelManager.MODELTYPE = .POSENET,
       upperBody: Bool = true,
       lowerBody: Bool = true) {
    super.init(calibration: Calibration(calibrationAsset: calibrationAsset), exerciseSettings: exerciseSettings)
    normalInit(modelType: personModelType, upperBody: upperBody, lowerBody: lowerBody)
  }
  
  // Default steps to initalize person class and the calibration class.
  func normalInit(modelType: ModelManager.MODELTYPE = .POSENET,
                  upperBody: Bool = true,
                  lowerBody: Bool = true) {
    person = PersonDetection(exerciseLead: false, modelType: modelType, upperBody: upperBody, lowerBody: lowerBody)
    person!.setExerciseLead(exerciseLead: true)
    person?.setMaxFps(fps: 24)
    objectDetections.append(person!)
    if calibration != nil {
      person!.getDetectionSubClasses().forEach { (objDet) in
        calibration?.addObjectDetection(objectDetection: objDet)
      }
    }
  }
  
  override func drawBoundingBox(canvas: UIView) {
    person?.drawBBox(canvas: canvas)
  }
  
  required init(exerciseSettings: OldExerciseSettings) {
    fatalError("init(viewController:exerciseSettings:) has not been implemented")
  }
  
  override func createAnswerEngine() -> AnswerEngine? {
    var aBuilder: AnswerBuilder? = AnswerEngine.builder()
    let aEngine: AnswerEngine? = aBuilder!
      .circle(radius: 0.1)
      .initPersonCenterPoint(person: self.person)
      .anyMatch(match: self.person!.leftArm!.wrist)
      .anyMatch(match: self.person!.leftArm!.index)
      .anyMatch(match: self.person!.rightArm!.wrist)
      .anyMatch(match: self.person!.rightArm!.index)
      .build()
    aBuilder = nil
    return aEngine
  }
  
  
  //MARK: Realtime Graph
  override func populateGraph() {
    graph.point.accept(person!.getHeadLine())
  }
  
}
