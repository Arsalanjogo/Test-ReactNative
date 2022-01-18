//
//  Theme.swift
//  jogo
//
//  Created by Muhammad Nauman on 26/07/2021.
//  Updated by Mohsin Tariq on 26/07/2021.
//

import Foundation

@objc protocol Theme {
  // MARK: Debug Colors
  // ===========================
  var primaryColor: UIColor { get set }
  var secondaryColor: UIColor { get set }
  // MARK: Exercise Colors
  // ===========================
  var footballColor: UIColor { get set }
  // MARK: Calibration Colors
  // ===========================
  var calibratedColor: UIColor { get set }
  var uncalibratedColor: UIColor { get set }
  // MARK: Debug Colors
  // ===========================
  var boneColor: UIColor { get set }
  var debugTextColor1: UIColor { get set }
  var debugTextColor2: UIColor { get set }
  var debugTextColor3: UIColor { get set }
  
}
