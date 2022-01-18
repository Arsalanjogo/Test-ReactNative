//
//  SpriteAssets.swift
//  Football433
//
//  Created by Muhammad Nauman on 15/12/2021.
//

import Foundation

class SpriteAssets {
  
  enum Promo: String {
    case SET_IN_POSITION = "set%20in%20position_1080"
  }
  
  enum Countdown: String {
    case COUNTDOWN = "COUNT_DOWN_20fps"
  }
  
  enum Score: String {
    case SCORE_TIMER = "bg_score"
    case SCORE_TIMER_ANIM = "SCORE_AND_TIMER_IN-20FPS"
    case INCREMENT = "Points+5"
    case DECREMENT = "SCORE_-2"
    case COLOR = "COLOR_INDICATOR"
    case PROGRESS_BAR = "PROGRESS_BAR_V02"
    case POWER = "POWERUP"
  }
  
  enum EndOfExercise: String {
    case WELLDONE = "ANIMATION_IN"
    case BALL_LOOP = "BALL%20LOOP"
    case STARS = "STARS"
    case LEVEL_FAILED = "LEVEL%20FAILED"
  }
  
}
