//
//  LottieMapping.swift
//  jogo
//
//  Created by arham on 08/07/2021.
//

import Foundation

struct CalibrationLottieStruct {
  let outline: String
  let correct: String
  let calibrate: String
}

public class LottieMapping {
  
  enum Area: String {
    case yellow = "YELLOW box"
    case red = "RED box"
  }
  
  enum Figures: String {
    case pawn = "Pawn"
  }
  
  enum Prompts: String {
    case up = "Indicate_Up"
    case down = "Indicate_Down"
    case jump = "Indicate_Jump"
    case kneel = "Indicate_Kneel"
  }
  
  enum RotationPrompt: String {
    case LEFT = "rotate left"
    case RIGHT = "rotate right"
    case UP = "tilt up"
    case DOWN = "tilt down"
    case ROTATION = "level_rotation"
    case TILT = "level_tilt_v03"
  }
  enum Buttons: String {
    case share = "Button Share"
    case home = "Button Home"
    case repeating = "Button Repeat"
  }
  enum Characters: String {
    case player = "Soccer player"
    case ball_ring = "Soccer ball tracker ring"
  }
  enum Opening: String {
    case alpha = "Opening Title generic Alpha"
    case glitch = "Overlay title glitch"
    case logo = "Opening Title generic LOGO"
    case finish = "Opening Title Finish"
    case gen_text_alpha = "Opening Title generic Text Alpha"
    case gen_text = "Opening Title generic TEXT"
    case countdown = "Combined Countdown"
  }
  enum Background: String {
    case green_in = "Title overlay background Green - In"
    case black_in_out = "Title overlay background Black - In -Out"
    case green_in_out = "Title overlay background Green - In - Out"
    case black_in = "Title overlay background Black - In"
  }
  enum Counters: String {
    case go_321_black50 = "Counter down 3-1 go 50_Black"
    case question_countdown = "Question countdown"
    case traffic_light = "Counter Traffic light circkel"
    case go_321_black100 = "Counter down 3-1 go 100_Black"
    case traffic_light_wrong = "Counter Traffic light wrong"
    case photo = "Photo highlight puls"
    case go_321_white100 = "Counter down 3-1 go 100_ White"
    case go_321_white50 = "Counter down 3-1 go 50_ White"
    case traffic_green = "Counter Traffic light green"
    case score_2_30 = "Counter score to 30 sec"
    case time_2_30 = "Counter time to 30 sec"
    case progression_bar = "Progession bar"
    case countdown_5_seconds = "countdown-54321"
  }
  enum GameText: String {
    case game = "Text Game"
    case ranking = "Text_Score Ranking"
    case get_in_position_bg = "Text Get in position Background"
    case score = "Text Score"
    case get_in_position_alpha = "Text Get in position Alpha"
    case plus1 = "Text +1"
  }
  
  enum LottieExercise {
    
    case HIGHKNEE
    case BALLPERSON
    case WALLSIT
    case SQUATS
    case LEGRAISES
    case SIDELEGRAISES
    case SITUPS
    case SIDEPLANKS
    case PLANKS
    case KNEEPUSHUPS
    case PUSHUPS
    case DEADLIFTS
    case BASIC

    var CalibrationAssets: CalibrationLottieStruct {
      switch self {
      case .HIGHKNEE:
        return CalibrationLottieStruct(outline: "High Knees calibration Outlines", correct: "High Knees calibration correct", calibrate: "High Knees calibration Calibrate")
      case .BALLPERSON:
        return CalibrationLottieStruct(outline: "Ball Calibration Outlines", correct: "ball Calibration Correct", calibrate: "Ball Calibration Calibrate")
      case .WALLSIT:
        return CalibrationLottieStruct(outline: "Wall sit calibration Outlines", correct: "Wall sit Calibrations Correct", calibrate: "Wall sit calibration Calibrate")
      case .SQUATS:
        return CalibrationLottieStruct(outline: "Squat calibration Outlines", correct: "Squat Calibration Correct", calibrate: "Squat Calibration Calibrate")
      case .LEGRAISES:
        return CalibrationLottieStruct(outline: "Leg raise calibration Outlines", correct: "Leg raise calibration Correct", calibrate: "Leg raise calibration Calibrate")
      case .SIDELEGRAISES:
        return CalibrationLottieStruct(outline: "Side leg raise outlines", correct: "Side leg raise Calibration Correct", calibrate: "Side leg raise calibration Calibrate")
      case .SITUPS:
        return CalibrationLottieStruct(outline: "Sit up Calibration Outlines", correct: "Sit up Calibration Correct", calibrate: "Sit up Calibration Calibrate")
      case .SIDEPLANKS:
        return CalibrationLottieStruct(outline: "Side plank calibration Outlines", correct: "Side plank calibration Correct", calibrate: "Side Plank Calibration Calibrate")
      case .PLANKS:
        return CalibrationLottieStruct(outline: "Plank Calibration Outlines", correct: "Plank calibration correct", calibrate: "Plank calibration calibrate")
      case .KNEEPUSHUPS:
        return CalibrationLottieStruct(outline: "Knee push up calibration Outlines", correct: "Knee push up calibration correct", calibrate: "Knee push up calibration calibrate")
      case .PUSHUPS:
        return CalibrationLottieStruct(outline: "Push up Calibration Outlines", correct: "Push up calibration Correct", calibrate: "Push up Calibration Calibrate")
      case .DEADLIFTS:
        return CalibrationLottieStruct(outline: "Deadlift calibration Outlines", correct: "Deadlift calibration Correct", calibrate: "Deadlift calibration Calibrate")
      case .BASIC:
        return CalibrationLottieStruct(outline: "Basic calibration outlines", correct: "Basic calibration correct", calibrate: "Basic calibration Calibrate")
      }
    }
  }
  
  private init() { }
  
}
