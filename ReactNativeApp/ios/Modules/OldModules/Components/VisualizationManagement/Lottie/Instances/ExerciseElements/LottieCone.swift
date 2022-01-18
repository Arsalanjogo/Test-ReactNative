//
//  LottieCone.swift
//  jogo
//
//  Created by Admin on 08/06/2021.
//

import Foundation

class LottieCone: LottieBase<LottieCone> {
  
  enum Direction {
    case LEFT, RIGHT
  }
  
  init(exerciseVC: ExerciseViewController) {
    super.init(exerciseVC: exerciseVC, animationName: LottieMapping.Figures.pawn.rawValue, targetView: nil)
    _ = try? self.minFrame(minFrame: 1.0).maxFrame(maxFrame: 25.0).ephemeral(ephemeral: false)
    var width: CGFloat
    var height: CGFloat
    if self.renderView.frame.width < self.renderView.frame.height {
      width = 0.2 * self.renderView.frame.width
      height = 1.5 * width
    } else {
      height = 0.2 * self.renderView.frame.height
      width = (3.0 / 4.0) * height
    }
    self.lottieAnimationView.frame.size = CGSize(width: width, height: height)
  }
  
  func fall(direction: Direction) {
    var angle: CGFloat
    switch direction {
    case .LEFT:
      angle = -90.0
    case .RIGHT:
      angle = 90.0
    }
    angle = (angle * CGFloat.pi) / 180.0
    UIView.animate(withDuration: 0.2) {
      self.lottieAnimationView.transform = CGAffineTransform(rotationAngle: angle)
    }
  }
  
  func stand(from: Direction) {
    let angle = (0 * CGFloat.pi) / 180.0
    UIView.animate(withDuration: 0.2) {
      self.lottieAnimationView.transform = CGAffineTransform(rotationAngle: angle)
    }
  }
  
}
