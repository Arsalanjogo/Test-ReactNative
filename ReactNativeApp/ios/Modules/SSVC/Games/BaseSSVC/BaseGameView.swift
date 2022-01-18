//
//  BaseGameView.swift
//  jogo
//
//  Created by arham on 18/11/2021.
//

import Foundation

class BaseGameView: DynamicSV {
  
  init(state: BaseGameState) {
    super.init(state: state, frame: RenderLoop.getFrame()!)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  
}
