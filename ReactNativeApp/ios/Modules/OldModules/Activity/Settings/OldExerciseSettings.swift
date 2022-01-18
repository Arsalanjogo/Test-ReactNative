//
//  ExerciseSettings.swift
//  jogo
//
//  Created by arham on 17/03/2021.
//

import AVFoundation
import Foundation

enum ExerciseSettingsError: Error {
  case CannotDecipherData
}

class OldExerciseSettings {
  // Handles interfacing of the Exercise Data and the creation of the Score module for the exercise.
  
  public enum QuestionTypes: String {
    case COLOR = "Color"
    case PICTURE = "Picture"
    case TEXT = "Text"
  }
  
  public let qMap: [String: QuestionTypes] = [
    "COLOR": QuestionTypes.COLOR,
    "PICTURE": QuestionTypes.PICTURE,
    "TEXT": QuestionTypes.TEXT,
  ]
  
  public enum ScoreTypes: String {
    case COUNTDOWN = "COUNTDOWN"
    case INFINITE = "INFINITE"
    case FAILURE = "FAILURE"
    case NREPETITIONS = "NREPETITIONS"
    case TOTALREPITIONS = "TOTALREPETITIONS"
    case QUESTION = "QUESTION"
    case HIGHSCORE = "HIGHSCORE"
    case NON_AI = "NON_AI"
    case NSECONDS = "NSECONDS"
    case TOTAL = "TOTAL"
    case TIMER = "TIMER"
  }
  
  public let scoreMap: [String: ScoreTypes] = [
    "COUNTDOWN": ScoreTypes.COUNTDOWN,
    "INFINITE": ScoreTypes.INFINITE,
    "FAILURE": ScoreTypes.FAILURE,
    "NREPETITIONS": ScoreTypes.NREPETITIONS,
    "TOTALREPITITIONS": ScoreTypes.TOTALREPITIONS,
    "QUESTION": ScoreTypes.QUESTION,
    "HIGHSCORE": ScoreTypes.HIGHSCORE,
    "NON_AI": ScoreTypes.NON_AI,
    "NONAI": ScoreTypes.NON_AI,
    "NSECONDS": ScoreTypes.NSECONDS,
    "TOTAL": ScoreTypes.TOTAL,
    "TIMERSCORE": ScoreTypes.TIMER,
  ]
  
  public let cameraMap: [Int: CameraFacing] = [
    1: CameraFacing.FRONT,
    0: CameraFacing.BACK,
  ]
  
  public static let DEBUG_MODE: Bool = true
  public static let RECORD_MODE: Bool = true
  
  public static var DRAWING_FPS = 30
  static let defaultQuestionModeString: String = "Color"
  static let defaultQuestionPath: String = "colorQuestion"
  static let defaultQuestionCount: Int = 5
  static let defaultAnswerCount: Int = 2
  
  private let defaultCountDown: Int = 30000
  private let defaultTimerLimit: Int = 30000
  private let defaultUsingQuestion: Bool = false
  private let defaultQuestionMode: QuestionTypes = .COLOR
  
  let settings: SettingsPayload
  let scoreType: ScoreTypes
  let cameraFacing: CameraFacing
  
  let questionMode: QuestionTypes
  let questionPath: String
  let questionCount: Int
  let answerCount: Int
  
  init(settings: Data?) throws {
    do {
      self.settings = try JSONDecoder().decode(SettingsPayload.self, from: settings!)
      self.scoreType = self.scoreMap[self.settings.exerciseType]!
      self.cameraFacing = CameraFacing(rawValue: self.settings.selectedCameraFacing)!
      self.questionMode = self.qMap[self.settings.questionMode ?? OldExerciseSettings.defaultQuestionModeString] ?? .COLOR
      self.questionPath = self.settings.questionPath ?? OldExerciseSettings.defaultQuestionPath
      self.questionCount = self.settings.questionCount ?? OldExerciseSettings.defaultQuestionCount
      self.answerCount = self.settings.answerCount ?? OldExerciseSettings.defaultAnswerCount
    } catch {
      Logger.shared.logError(error: error)
      throw ExerciseSettingsError.CannotDecipherData
    }
  }
  
  public func getCameraFacing() -> CameraFacing {
    return self.cameraFacing
  }
  
  public func getCountDownMilliseconds() -> Int {
    return self.settings.countDownMiliSeconds == 0 ? self.defaultCountDown : self.settings.countDownMiliSeconds
  }
  
  public func getScoreType() -> ScoreTypes {
    return self.scoreType
  }
  
  public func getScore() -> Int {
    return self.settings.score
  }
  
  public func getHighScore() -> Int {
    return self.settings.highScore == nil ? 0 : self.settings.highScore!
  }
  
  public func createScore(baseExercise: BaseExercise) -> BaseScore {
    switch scoreType {
    case .COUNTDOWN:
      return CountdownScore(baseExercise: baseExercise, time: Double(self.getCountDownMilliseconds()))
    case .INFINITE:
      return InfiniteScore(baseExercise: baseExercise)
    case .FAILURE:
      return TillFailureScore(baseExercise: baseExercise)
    case .NREPETITIONS:
      return NRepititions(baseExercise: baseExercise, reptitions: self.getScore())
    case .TOTALREPITIONS:
      return NRepititions(baseExercise: baseExercise, reptitions: self.getScore())
    case .QUESTION:
      return QuestionScore(baseExercise: baseExercise, questionCount: self.questionCount)
    case .HIGHSCORE:
      return HighScore(baseExercise: baseExercise, highScore: self.getHighScore())
    case .NON_AI:
      return InfiniteScore(baseExercise: baseExercise)
    case .NSECONDS:
      return TimerScore(baseExercise: baseExercise, time: Double(self.getCountDownMilliseconds()))
    case .TOTAL:
      return TimerScore(baseExercise: baseExercise, time: Double(self.getCountDownMilliseconds()))
    case .TIMER:
      return TimerScore(baseExercise: baseExercise, time: Double(self.getCountDownMilliseconds()))
    
    }
  }
  
  public func getExerciseVariation() -> Int {
    return self.settings.exerciseVariation == nil ? 0 : self.settings.exerciseVariation!
  }
  
  public func usingQuestion() -> Bool {
    return self.settings.useQuestions == nil ? self.defaultUsingQuestion : self.settings.useQuestions!
  }

  func getDescription () -> String {
    return self.settings.description == nil ? "No description currently available" : self.settings.description!
  }
  
  func getQuestionMode() -> QuestionTypes {
    return self.questionMode
  }
}

// Look at this https://app.quicktype.io/
// Serialization of a JSON to a struct.
struct SettingsPayload: Codable {
  var highScore: Int?
  var exerciseVariation: Int?
  var exerciseType: String
  var countDownMiliSeconds: Int
  var description: String?
  var score: Int
  var useQuestions: Bool?
  var selectedCameraFacing: Int
  var questionMode: String?
  var questionPath: String?
  var questionCount: Int?
  var answerCount: Int?
}
