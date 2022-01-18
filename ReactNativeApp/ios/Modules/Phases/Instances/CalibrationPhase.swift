//
//  CalibrationPhase.swift
//  jogo
//
//  Created by Mohsin on 22/10/2021.
//

import Foundation

public class CalibrationPhase: Phase {
  
  var sensorCalibration: SSVC<SensorCalibrationState, SensorCalibrationView, SensorCalibrationController>!
  var exerciseCalibration: SSVC<ExerciseCalibrationState, ExerciseCalibrationView, ExerciseCalibrationController>!
  var calibrationVisuals: SSVC<CalibrationVisualsState, CalibrationVisualsView, CalibrationVisualsController>!
  var person: PersonSSVC<PersonState, PersonView, PersonController>!
  var ball: BallSSVC<BallState, BallView, BallController>!
  
  public override func process() {
    exerciseCalibration.controller.process()
    person.controller.changeCalibrationStatus(isCalibrated: exerciseCalibration.controller.isPersonCalibrated())
    ball.controller.changeCalibrationStatus(isCalibrated: exerciseCalibration.controller.isBallCalibrated())
    super.process()
    Profiler.get().profileTime(frameId: GameContext.getContext()?.currentFrameNumber ?? -1, tag: "\(self.phaseName ?? "" )-\(#function)", delta: Date().getMilliseconds() - timings["\(#function)"]!)
  }
  
  public override func isDone() -> Bool {
    return sensorCalibration.controller.isRotationCalibrated() && exerciseCalibration.controller.isCalibrated()
  }
  
  public override func initialize() {
    self.phaseName = "Calibration"
    self.prevPhase = .PromoPhase
    self.nextPhase = .CountDownPhase
    // Build Sensor Calibration SSVC
    sensorCalibration = SensorCalibrationBuilder.build()
    
    // Build Exercise Calibration SSVC
    exerciseCalibration = ExerciseCalibrationBuilder.build()
    
    calibrationVisuals = CalibrationVisualsBuilder.build()
    calibrationVisuals.controller.setDelegateToButton(phase: self, action: #selector(questionMarkBtnAction(_:)))
    person = PersonBuilder.build(state: GameContext.getContext()!.personState!)
    ball = BallBuilder.build(state: GameContext.getContext()!.ballState!)
    ball.changeView(drawType: .POINT)
    super.initialize()
    Profiler.get().profileTime(frameId: GameContext.getContext()?.currentFrameNumber ?? -1, tag: "\(self.phaseName ?? "" )-\(#function)", delta: Date().getMilliseconds() - timings["\(#function)"]!)
  }
  
  @objc func questionMarkBtnAction(_ sender: UIButton) {
    self.delegate?.changePhase(to: .VideoPhase)
  }
  
  public override func cleanup() {
    super.cleanup()
    self.sensorCalibration.cleanup()
    self.exerciseCalibration.cleanup()
    self.calibrationVisuals.cleanup()
    self.person.cleanup(with: false)
    self.ball.cleanup(with: false)
    self.sensorCalibration = nil
    self.exerciseCalibration = nil
    self.calibrationVisuals = nil
    self.person = nil
    self.ball = nil
    Profiler.get().profileTime(frameId: GameContext.getContext()?.currentFrameNumber ?? -1, tag: "\(self.phaseName ?? "" )-\(#function)", delta: Date().getMilliseconds() - timings["\(#function)"]!)
  }
  
  public override func getDebugText() -> String {
//    return "isSensorCalibrated: \(sensorCalibration.controller.isRotationCalibrated()) \nisExerciseCalibrated: \(exerciseCalibration.controller.isCalibrated())"
//    GameContext.getContext()!.objectDetections.forEach { objState in
//
//      (objState as? PersonState)?.getDetectionSubClasses().forEach({ subStates in
//        print("\(subStates.getLabel()), \(subStates.getX()), \(subStates.getY())")
//      })
//
//      print((objState as? BallState)?.description)
//    }
    return GameContext.getContext()!.objectDetections.description
  }
}
