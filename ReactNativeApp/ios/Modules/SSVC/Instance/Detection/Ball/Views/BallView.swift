//
//  BallView.swift
//  jogo
//
//  Created by arham on 04/11/2021.
//

import Foundation
import UIKit

class BallView: DynamicSV {
  
  init(state: BallState) {
    super.init(state: state, frame: RenderLoop.getFrame()!)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
}
