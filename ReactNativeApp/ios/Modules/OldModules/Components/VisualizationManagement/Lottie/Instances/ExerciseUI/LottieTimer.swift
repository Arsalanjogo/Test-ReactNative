//
//  LottieTimer.swift
//  jogo
//
//  Created by Muhammad Nauman on 22/05/2021.
//

import Foundation
import UIKit

class LottieTimer: LottieBase<LottieTimer>{
  
  init(exerciseVC: ExerciseViewController) {
    super.init(exerciseVC: exerciseVC, animationName: LottieMapping.Counters.time_2_30.rawValue, targetView: UIView())
//    _ = try? self.minFrame(minFrame: 3.0).maxFrame(maxFrame: 20.0).ephemeral(ephemeral: false)
  }
  
  func blink() {
    DispatchQueue.main.async {
      _ = try? self.minFrame(minFrame: 38.0).maxFrame(maxFrame: 50.0).play()
    }
  }
  
}
