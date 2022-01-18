//
//  LottieFinish.swift
//  jogo
//
//  Created by Muhammad Nauman on 23/05/2021.
//

import Foundation

class LottieFinish: LottieBase<LottieFinish>{
  
  var finish: LottieRender?
  
  init(exerciseVC: ExerciseViewController) {
    finish = try? LottieRender(exerciseVC: exerciseVC, animationName: "Opening Title Finish").scale(x: 1.0, y: 0.5).move(x: 0.5, y: 0.5).contentMode(mode: .scaleAspectFit)
    super.init(exerciseVC: exerciseVC, animationName: "Title overlay background Black - In -Out", targetView: nil)
    _ = try? self.minFrame(minFrame: 1.0).maxFrame(maxFrame: 34.0).onStart { [weak self] in
      self?.renderView.scoreView.isHidden = true
//      self?.renderView.progressionBar.isHidden = true
    }
  }
  
  override func play() {
    _ = try? self.play(completion: {
      _ = try? self.finish?.play(completion: {
        self.exerciseViewController.stopVideoCapture()
        self.exerciseViewController.exercise?.writeToJson()
        Profiler.get().saveProfile()
        // self.exerciseViewController.dismiss(animated: true, completion: nil)
        self.clearDidStart()
      })
    })
  }
  
}
