//
//  PromoView.swift
//  jogo
//
//  Created by Muhammad Nauman on 08/11/2021.
//

import Foundation
import Lottie
import SceneKit

public class PromoView: LayoutSV {
  
//  var promoAnimationView: AnimationView!
  
  var promoAnimNode: AnimationNode?
  
  init(state: PromoState) {
    super.init(state: state, frame: RenderLoop.getFrame()!)
//    promoAnimationView = AnimationView(animation: Animation.named(LottieMapping.Opening.gen_text.rawValue))
//    promoAnimationView.frame = self.frame
//    self.addSubview(promoAnimationView)
    
//    promoAnimationView.play { success in
//      if success{
//        state.isPromoEnded = true
//      }
//    }
  }
  
  override func prepareAnimation() {
    self.promoAnimNode = AnimationNode(size: bounds.size, position: center, atlasName: SpriteAssets.Promo.SET_IN_POSITION.rawValue)
    guard let promoAnimNode = promoAnimNode else {
      return
    }
    self.animationOverlay?.addChild(promoAnimNode)
    promoAnimNode.playAnimation(shouldRepeat: false) { }
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override func draw(canvas: UIView) {
    super.draw(canvas: canvas)
  }
  
  public override func cleanup() {
    self.promoAnimNode?.cleanup()
    self.promoAnimNode = nil
    super.cleanup()
  }
  
}
