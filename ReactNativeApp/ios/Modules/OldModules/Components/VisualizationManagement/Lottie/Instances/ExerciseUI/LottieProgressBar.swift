//
//  LottieProgressBar.swift
//  jogo
//
//  Created by Muhammad Nauman on 10/09/2021.
//

import Foundation

class LottieProgressBar: LottieBase<LottieProgressBar>{
  
  init(exerciseVC: ExerciseViewController) {
    super.init(exerciseVC: exerciseVC, animationName: LottieMapping.Counters.progression_bar.rawValue, targetView: nil)
    let _ = try? self.contentMode(mode: .scaleAspectFit)
  }
  
}
