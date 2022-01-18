//
//  Theme1.swift
//  jogo
//
//  Created by Muhammad Nauman on 26/07/2021.
//  Updated by Mohsin Tariq on 26/07/2021.
//

import Foundation

@objc class Theme1: NSObject, Theme {
  
  private static let jogoYellow = UIColor(
    red: 219.0 / 255.0,
    green: 255.0 / 255.0,
    blue: 0,
    alpha: 1
  )
  
  // ===========================
  // MARK: Theme Palette
  // ===========================
  
  /**
   White
   */
  var white: UIColor = UIColor.white
  
  /**
  JOGO Yellow
  */
  var primaryColor: UIColor = jogoYellow
  
  /**
  Black
  */
  var secondaryColor: UIColor = UIColor.black
  
  // ===========================
  // MARK: Exercise Colors
  // ===========================
  
  var footballColor: UIColor = UIColor(red: 255, green: 25, blue: 25)
  
  // ===========================
  // MARK: Calibration Colors
  // ===========================
  
  /**
   JOGO Yellow
  */
  var calibratedColor: UIColor = jogoYellow
  
  /**
  Red
  */
  var uncalibratedColor: UIColor = UIColor.red
  
  // ===========================
  // MARK: Debug Colors
  // ===========================
  
  /**
  Yellow
  */
  var boneColor: UIColor = UIColor(
    red: 249 / 255.0,
    green: 203 / 255.0,
    blue: 64 / 255.0,
    alpha: 1.0
  )
  
  /**
  Red
  */
  var debugTextColor1: UIColor = UIColor.red
  
  /**
  Green
  */
  var debugTextColor2: UIColor = UIColor.green
  
  /**
  Blue
  */
  var debugTextColor3: UIColor = UIColor.blue
}
