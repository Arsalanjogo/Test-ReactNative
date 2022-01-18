//
//  ExerciseEnum.swift
//  jogo
//
//  Created by Muhammad Nauman on 14/06/2021.
//

import Foundation

class ExerciseManager {
  
  static let shared = ExerciseManager()
  
  let exercises: [BaseExercise.Type] = []
  
  func getExercise(formatName: String) -> BaseExercise.Type? {
    for exercise in exercises {
      if exercise.getName() == formatName {
        return exercise
      }
    }
    return nil
  }
  
  private init() {
    
  }
  
  @objc func restartExercise() {
      if ExerciseViewController.baseViewController == nil { return }
      if BaseExercise.getExercise() == nil { return }
      if BaseExercise.getExercise()!.status == .COUNTDOWN { return }
      DispatchQueue.main.async {
        ExerciseViewController.baseViewController!.exerciseState = .RESTART
        LottieRestart(exerciseVC: ExerciseViewController.baseViewController!).play()
      }
    }
    
    @objc func switchExercise() {
      if ExerciseViewController.baseViewController == nil { return }
      if BaseExercise.getExercise() == nil { return }
      if BaseExercise.getExercise()!.status == .COUNTDOWN { return }
      DispatchQueue.main.async {
        ExerciseViewController.baseViewController!.exerciseState = .RESTART
        DispatchQueue.main.asyncAfter(deadline: .now() + ExerciseViewController.baseViewController!.restartPauseTime) {
          BaseExercise.getExercise()!.stop(endVC: false)
          BaseExercise.getExercise()!.writeToJson()
          ExerciseViewController.baseViewController!.exerciseCompleteHelper()
          ExerciseViewController.baseViewController!.exercise = nil
          BaseExercise.baseExercise = nil
          // TODO: Remove this setExercise(id to something dynamically set for the netflix module.
          ExerciseViewController.baseViewController!.setExercise(exerciseId: "17")
          ExerciseViewController.baseViewController!.exercise = ExerciseViewController.baseViewController!.getExercise()
          BaseExercise.baseExercise = ExerciseViewController.baseViewController!.exercise
          ExerciseViewController.baseViewController!.modelManager?.reset()
          ExerciseViewController.baseViewController!.reset()
//          ExerciseViewController.baseViewController!.modelManager?.setIOStream(ioStream: ExerciseViewController.baseViewController!)
          ExerciseViewController.baseViewController!.exerciseState = .NORMAL
        }
      }
    }
  
  func getExercise(id: String) -> BaseExercise.Type? {
    
    switch id {
    case "213":
      return BuildableExercise.self
    default:
//      guard let exerciseId = Int(id) else { return nil }
//      if exerciseId >= 1 && exerciseId <= 214 {
//        return NonAIBallPersonExercise.self
//      }
//      else{
//        return NonAIPersonExercise.self
//      }
      return nil
    }
    
  }
  
}
