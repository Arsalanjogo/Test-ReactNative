//
//  AnimationOverlay.swift
//  jogo
//
//  Created by Muhammad Nauman on 24/11/2021.
//

import Foundation
import SpriteKit

public class AnimationOverlay: SKScene, CleanupProtocol {
  
  var animationNode = SKSpriteNode()
  var prepareAnimation: (()->Void)?
  
  init(size: CGSize, prepareAnimation: (()->Void)?) {
    super.init(size: size)
    self.prepareAnimation = prepareAnimation
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override func didMove(to view: SKView) {
    self.prepareAnimation?()
  }
  
  func cleanup() {
    self.prepareAnimation = nil
    self.animationNode.removeAllChildren()
    self.animationNode.removeFromParent()
  }
  
  
  
  
  
}

