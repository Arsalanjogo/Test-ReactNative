//
//  FinishView.swift
//  jogo
//
//  Created by Mohsin on 24/11/2021.
//

import Foundation

import Lottie

public class FinishView: LayoutSV {
  
  var animationBackground: AnimationView!
  var animationForeground: AnimationView!
  
  init(state: FinishState) {
    super.init(state: state, frame: RenderLoop.getFrame()!)
    
    animationBackground = AnimationView(animation: Animation.named(LottieMapping.Background.black_in_out.rawValue))
    animationBackground.frame = self.frame
    self.addSubview(animationBackground)
    
    animationForeground = AnimationView(animation: Animation.named(LottieMapping.Opening.finish.rawValue))
    animationForeground.frame = self.frame
    self.addSubview(animationForeground)
    
    RenderLoop.addStaticLayoutStateView(layoutSV: self)
    animationBackground.play()
    animationForeground.play { success in
      if success {
        state.isEnded = true
      }
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
}
