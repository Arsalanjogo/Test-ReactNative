//
//  BuildableExercise.swift
//  jogo
//
//  Created by arham on 09/08/2021.
//

import Foundation

class BuildableExercise: BaseExercise {
  
  private var stateMapper: StateMapper?
  
  
  required init(exerciseSettings: OldExerciseSettings) {
    super.init(calibration: Calibration(calibrationAsset: .BASIC), exerciseSettings: exerciseSettings)
    let person: PersonDetection = PersonDetection(exerciseLead: true, modelType: .POSENET)
    person.setExerciseLead(exerciseLead: true)
    person.setMaxFps(fps: 24)
    objectDetections.append(person)
    if (calibration != nil) {
      person.getDetectionSubClasses().forEach { (objDet) in
        calibration?.addObjectDetection(objectDetection: objDet)
      }
    }
    self.buildExercise()
    
  }
  
  public func loadJson(fileName: String) -> ExerciseCodable? {
     let decoder = JSONDecoder()
     guard
          let url = Bundle.main.url(forResource: fileName, withExtension: "json"),
          let data = try? Data(contentsOf: url),
          let exercisej = try? decoder.decode(ExerciseCodable.self, from: data)
     else {
          return nil
     }

     return exercisej
  }
  
  public func buildExercise() {
    let obj: ExerciseCodable? = self.loadJson(fileName: "jj")
    if obj == nil {
      Logger.shared.log(logType: .ERROR, message: "Exercise JSON was not imported correctly.")
      return
    }
    self.stateMapper = StateMapper(value: obj!.state)
  }
  
  override func drawExerciseDebug(canvas: UIView) {
    PersonDetection.shared?.drawDebug(canvas: canvas)
    stateMapper?.drawDebug(canvas: canvas)
  }
  
  func getName() -> String {
    return "Custom Buildable Exercise"
  }
  
  override func drawExercise(canvas: UIView) {
    
  }
  
  override func processExercise(infoBlob: InfoBlob) {
    stateMapper?.process()
  }
  
  override func createQuestionEngine() -> QuestionEngine {
    return QuestionEngine.builder().build()!
  }

}
