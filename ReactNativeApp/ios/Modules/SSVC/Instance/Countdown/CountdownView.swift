//
//  CountdownView.swift
//  jogo
//
//  Created by Mohsin on 12/11/2021.
//

import Foundation
import Lottie
import SceneKit

public class CountdownView: LayoutSV {
  
//  var animationView: AnimationView!
//  var backgroundView: AnimationView!

  var countdownAnimNode: AnimationNode?
  
  var countDownSound: SoundRender?
  
  
  init(state: CountdownState) {
    super.init(state: state, frame: RenderLoop.getFrame()!)
    countDownSound = SoundRender(value: SoundMapping.Score.Count_Down.Asset)
    let _ = countDownSound?.play()
//    animationView = AnimationView(animation: Animation.named("COUNT DOWN"))
////    backgroundView = AnimationView(animation: Animation.named(LottieMapping.Background.green_in_out.rawValue))
//    animationView.frame = self.frame
////    backgroundView.frame = self.frame
////    backgroundView.contentMode = .scaleToFill
////    self.addSubview(backgroundView)
//    self.addSubview(animationView)
    
    self.playAnimation()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  func playAnimation() {
//    animationView.play { success in
//      (self.state as! CountdownState).isCountdownEnded = true
//    }
//    backgroundView.play(fromFrame: 1.0, toFrame: 40.0, loopMode: .playOnce) { [weak self] completed in
//      (self?.state as! CountdownState).isBackgroundFilled = true
//      _ = self?.countDownSound.play()
//      self?.animationView.play { [weak self] success in
//        if success {
//          self?.backgroundView.play(fromFrame: 80, toFrame: 98, loopMode: .playOnce, completion: { [weak self] finalSuccess in
//            (self?.state as! CountdownState).isCountdownEnded = true
//          })
//        }
//      }
//    }
    
  }
  
  override func prepareAnimation() {
    self.countdownAnimNode = AnimationNode(size: bounds.size, position: center, atlasName: SpriteAssets.Countdown.COUNTDOWN.rawValue)
    guard let countdownAnimNode = countdownAnimNode else {
      return
    }
    self.animationOverlay?.addChild(countdownAnimNode)
    countdownAnimNode.playAnimation(shouldRepeat: false) { [weak self] in
      (self?.state as? CountdownState)?.isCountdownEnded = true
    }
  }
  
  public override func cleanup() {
    self.countdownAnimNode?.cleanup()
    self.countdownAnimNode = nil
    self.countDownSound = nil
    super.cleanup()
  }
}
