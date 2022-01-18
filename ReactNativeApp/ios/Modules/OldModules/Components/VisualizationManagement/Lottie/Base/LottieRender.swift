//
//  LottieRender.swift
//  jogo
//
//  Created by Muhammad Nauman on 17/04/2021.
//

import Foundation
import Lottie

class LottieRender: LottieBase<LottieRender> {
  
  init(exerciseVC: ExerciseViewController, animationName: String) {
    super.init(exerciseVC: exerciseVC, animationName: animationName, targetView: nil)
  }
  
}
