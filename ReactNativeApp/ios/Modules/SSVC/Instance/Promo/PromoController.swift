//
//  PromoController.swift
//  jogo
//
//  Created by Muhammad Nauman on 08/11/2021.
//

import Foundation

public class PromoController: Controller {
  
  var getInPositionSound = SoundRender(value: SoundMapping.Misc.GET_IN_POSITION.Asset)
  
  init(state: PromoState) {
      super.init(state: state)
    let _ = getInPositionSound.speed(value: 0.75).onEnd {
      (self.state as? PromoState)?.isPromoEnded = true
    }.play()
  }
  
  func isDone() -> Bool {
      return (self.state as? PromoState)?.isPromoEnded ?? false
  }
  
}
