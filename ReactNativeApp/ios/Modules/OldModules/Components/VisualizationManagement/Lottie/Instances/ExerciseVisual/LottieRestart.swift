//
//  LottieRestart.swift
//  jogo
//
//  Created by arham on 06/09/2021.
//

import Foundation

class LottieRestart: LottieBase<LottieRestart>{
  
  var finish: LottieRender?
  
  init(exerciseVC: ExerciseViewController) {
    finish = try? LottieRender(exerciseVC: exerciseVC, animationName: "Opening Title Finish").scale(x: 1.0, y: 0.5).move(x: 0.5, y: 0.5).contentMode(mode: .scaleAspectFit)
    super.init(exerciseVC: exerciseVC, animationName: "Title overlay background Black - In -Out", targetView: nil)
    _ = try? self.minFrame(minFrame: 1.0).maxFrame(maxFrame: 34.0).onStart { [weak self] in
      self?.renderView.scoreView.isHidden = true
    }
  }
  
  override func play() {
    _ = try? self.play(completion: {
      _ = try? self.finish?.play(completion: { [unowned self] in
        self.exerciseViewController.modelManager?.reset()
        self.exerciseViewController.reset()
        self.exerciseViewController.exercise?.reset()
        self.exerciseViewController.exercise?.objectDetections.forEach { objDet in
          objDet.reset()
        }
        self.lottieAnimationView.isHidden = true
        finish?.lottieAnimationView.isHidden = true
        self.exerciseViewController.exerciseState = .NORMAL
      })
    })
  }
  
}
