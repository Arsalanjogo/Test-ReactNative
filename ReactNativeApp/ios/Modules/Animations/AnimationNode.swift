//
//  AnimationNode.swift
//  Football433
//
//  Created by Muhammad Nauman on 14/12/2021.
//

import Foundation
import SpriteKit

class AnimationNode: SKSpriteNode, CleanupProtocol {
  
  var animationFrames: [SKTexture] = []
  var atlasName: String!
  let fps = 20.0
  
  init(size: CGSize, position: CGPoint, atlasName: String) {
    super.init(texture: nil, color: .clear, size: size)
    self.size = size
    self.atlasName = atlasName
    self.buildAnimation()
    self.texture = self.animationFrames.first
    self.aspectFillToSize(fillSize: self.frame.size)
    self.position = position
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
//    fatalError("init(coder:) has not been implemented")
  }
  
  func playAnimation(shouldRepeat: Bool, completion: @escaping ()->Void) {
    if shouldRepeat{
      self.run(SKAction.repeatForever(SKAction.animate(with: animationFrames, timePerFrame: 1.0/fps)))
    } else {
      self.run(SKAction.animate(with: animationFrames, timePerFrame: 1.0/fps)) {
        completion()
      }
    }
  }

  // For Playing Animations from Specfic Frames:
  func playAnimationFramesWithTimer(exerciseTime: Double? = nil) {
    guard let frame = exerciseTime else { return }
    
    let frameDuration = animationFrames.count.doubleValue/frame
    
    self.run(SKAction.animate(with: animationFrames, timePerFrame: 1.0/frameDuration))
  }

  func playAnimationFrames(fromFrame: Int, toFrame: Int) {
    let renderAnimationFrame: [SKTexture] = Array(animationFrames[fromFrame...toFrame])
    self.run(SKAction.animate(with: renderAnimationFrame, timePerFrame: 1.0/10))
  }
  
  // For Playing Static Images:
  func playAnimationImage() {
    self.run(SKAction.setTexture(SKTexture(imageNamed: self.atlasName)))
  }
  
  func createName(number: Int) -> String {
    let strNum = String(number)
    let numZeros = 5 - strNum.count
    var name = ""
    for _ in 0 ..< numZeros {
      name += "0"
    }
    name += "\(number)"
    return name
  }
  
  func buildAnimation() {
    let animatedAtlas = SKTextureAtlas(named: atlasName)
    var walkFrames: [SKTexture] = []

    let numImages = animatedAtlas.textureNames.count
    for i in 0 ..< numImages {
//      let bearTextureName = "\(atlasName)\(i)"
      let name = createName(number: i)
      walkFrames.append(animatedAtlas.textureNamed("\(atlasName!)_\(name)"))
    }
    animationFrames = walkFrames
  }
  
  func cleanup() {
    self.removeAllChildren()
    self.removeFromParent()
    self.animationFrames.removeAll()
  }
  
}

extension SKSpriteNode {

    func aspectFillToSize(fillSize: CGSize) {

        if texture != nil {
            self.size = texture!.size()

            let verticalRatio = fillSize.height / self.texture!.size().height
            let horizontalRatio = fillSize.width /  self.texture!.size().width

            let scaleRatio = horizontalRatio > verticalRatio ? horizontalRatio : verticalRatio

            self.setScale(scaleRatio)
        }
    }
}

extension Int {
  var doubleValue: Double {
    return Double(self)
  }
}
