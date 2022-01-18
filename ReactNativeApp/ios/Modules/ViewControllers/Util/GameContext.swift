//
//  ExerciseContext.swift
//  jogo
//
//  Created by arham on 03/11/2021.
//

import Foundation


enum EnumObjectDetection {
  case Person
  case Ball
}

public enum CameraFacing: Int {
  case FRONT = 0
  case BACK = 1
  case BOTH = 2
}

public enum GameOrientation: String {
  case PORTRAIT
  case LANDSCAPE
}

class GameContext: CleanupProtocol {
  
  private static var context: GameContext?
  
  public static func getContext() -> GameContext? {
    return self.context
  }
  
  internal var gamePhaseName: GamePhasesName?
  internal var fileName: String
  internal var exerciseTime: Double?
  internal var gameDuration: Double?
  
  internal var modelManager: ModelManager?
  internal var sensorManager: SensorManager?
  internal final var personState: PersonState?
  internal final var ballState: BallState?
  
  internal final var objectDetections: [ObjectDetectionState] = [ObjectDetectionState]()
  
  internal var infoBlobArrayList: UtilArrayList<InfoBlob> = UtilArrayList<InfoBlob>()
  
  internal final var cameraFacing: CameraFacing? = .BACK
  internal final var applicationOrientation: GameOrientation?
  internal var currentFrameNumber: Int = 0
  internal var currentScore: Int = 0
  
  init(gameInformation: PayLoad, exerciseVC: ExerciseVC) {
    self.fileName = gameInformation.payload
    gameDuration = gameInformation.duration
    applicationOrientation = GameOrientation(rawValue: gameInformation.orientation)
    sensorManager = SensorManager.getInstance()
    modelManager = ModelManager.createInstance(ioStream: exerciseVC)
    GameContext.context = self
  }
  
  public func getCurrentFrameNumber() -> Int {
    return self.currentFrameNumber
  }
  
  public func setCurrentFrameNumber(value: Int) {
    self.currentFrameNumber = value
  }
  
  public func setGameName(name: String?) {
    guard let value = name else { return }
    self.gamePhaseName = GamePhasesName(rawValue: value)
  }
  
  public func getGame() -> GamePhasesName? {
    self.gamePhaseName
  }
  
  public func setInfoBlob(value: InfoBlob) {
    _ = self.infoBlobArrayList.add(value: value)
  }
  
  public func initializeObjectsAndModels(objectsToUse: [modelObjectRelation]) {
    objectsToUse.forEach { mOR in
      switch mOR.objectDetection {
      case .Person:
        personState = PersonBuilder.buildState(modelType: mOR.modelType, exerciseLead: false)
        objectDetections.append(personState!)
      case .Ball:
        ballState = BallBuilder.buildState(modelType: mOR.modelType, exerciseLead: false)
        objectDetections.append(ballState!)
      case .none:
        Logger.shared.logError(text: "\(mOR.objectDetection ?? .Person) - \(mOR.modelType)")
      }
    }
    
    if ballState != nil {
      ballState?.setExerciseLead(exerciseLead: true)
      if personState == nil {
        ballState?.setMaxFps(fps: 25)
      } else {
        ballState?.setMaxFps(fps: 18)
      }
    } else if personState != nil {
      personState?.setExerciseLead(exerciseLead: true)
      if ballState == nil {
        personState?.setMaxFps(fps: 24)
      } else {
        personState?.setMaxFps(fps: 15)
      }
    }
  }
  
  // MARK: Cleanup logic below here.
  
  /// Cleans up all the properties holding references to exercise related objects.
  public func cleanup() {
    self.cleanupObjectDetectionStates()
    self.cleanupModelManager()
    self.cleanupSensorManager()
    self.cleanupInfoBlobs()
  }
  
  /// Cleans up the infoBlob utilArrayList so it has no elements present in it.
  private func cleanupInfoBlobs() {
    self.infoBlobArrayList.clear()
  }
  
  /// Deinitializes any current sensor running.
  /// Removes the SensorManager reference itself so it can be removed.
  private func cleanupSensorManager() {
    self.sensorManager?.deinitialize()
    self.sensorManager = nil
    SensorManager.removeInstance()
  }
  
  /// Tells the modelManager to stop and all the underlying models to also stop as
  /// well as remove the references to those models in the ModelManager.
  private func cleanupModelManager() {
    self.modelManager?.stop()
    self.modelManager?.exit()
    self.modelManager = nil
    ModelManager.removeInstance()
  }

  /// Gets all the child ObjectDetectionStates in the Current GameContext.
  /// Tells em to unsubscribe.
  private func cleanupObjectDetectionStates() {
    var _location: [ObjectDetectionState]? = []
    self.objectDetections.forEach { objState in
      objState.cleanup()
    }
    _location = nil
    self.objectDetections  = []
    self.personState = nil
    self.ballState = nil
  }
  
}
