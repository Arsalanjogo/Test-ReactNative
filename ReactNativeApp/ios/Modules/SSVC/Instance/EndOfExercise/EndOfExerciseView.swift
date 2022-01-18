//
//  SuccessfulView.swift
//  Football433
//
//  Created by Muhammad Nauman on 14/12/2021.
//

import Foundation
import SceneKit
import SpriteKit

public class EndOfExerciseView: LayoutSV {
  
  var backgroundAnimNode: AnimationNode?
  var ballAnimNode: AnimationNode?
  var starsAnimNode: AnimationNode?
  var scoreLblNode: SKLabelNode?
  
  init(state: EndOfExerciseState) {
    super.init(state: state, frame: RenderLoop.getFrame()!)
    
    //TODO: Need to check this logic from Exercise Settings when implementing exercise settings
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func prepareAnimation() {
    if GameContext.getContext()?.currentScore ?? 0 >= 5{
      self.prepareSuccessfulAnimation()
    } else {
      self.prepareFailureAnimation()
      addTryAgainButton()
    }
  }
  
  func prepareSuccessfulAnimation() {
    let width = self.frame.width
    let height = self.frame.height
    let centerScaleFactor = 0.6
    let size = width < height ? (centerScaleFactor*width) : (centerScaleFactor*height)
    let x = bounds.midX//0.2 * width
    let y = bounds.midY //1.2 * 
    self.backgroundAnimNode = AnimationNode(size: CGSize(width: size, height: size), position: CGPoint(x: x, y: y), atlasName: SpriteAssets.EndOfExercise.WELLDONE.rawValue)
    guard let backgroundAnimNode = backgroundAnimNode else {
      return
    }
    self.animationOverlay?.addChild(backgroundAnimNode)
    
    self.ballAnimNode = AnimationNode(size: CGSize(width: size, height: size), position: CGPoint(x: x, y: y), atlasName: SpriteAssets.EndOfExercise.BALL_LOOP.rawValue)
    guard let ballAnimNode = ballAnimNode else {
      return
    }
    ballAnimNode.zPosition = 1
    ballAnimNode.isHidden = true
    animationOverlay?.addChild(ballAnimNode)
    
    self.starsAnimNode = AnimationNode(size: CGSize(width: size, height: size), position: CGPoint(x: x, y: y), atlasName: SpriteAssets.EndOfExercise.STARS.rawValue)
    guard let starsAnimNode = starsAnimNode else {
      return
    }
    starsAnimNode.zPosition = 2
    starsAnimNode.isHidden = true
    self.animationOverlay?.addChild(starsAnimNode)
    
    self.scoreLblNode = SKLabelNode(text: "\(GameContext.getContext()?.currentScore ?? 0)")
    guard let scoreLblNode = scoreLblNode else {
      return
    }
    let labelSize = 0.3 * size
    self.adjustLabelFontSizeToFitRect(labelNode: scoreLblNode, rect: CGRect(x: 0, y: 0, width: labelSize, height: labelSize))
    scoreLblNode.position = CGPoint(x: 0, y: -(0.55*(size/2)))
    scoreLblNode.fontName = "MonoSpec-Medium"
    scoreLblNode.isHidden = true
    scoreLblNode.zPosition = 3
    backgroundAnimNode.addChild(scoreLblNode)
    backgroundAnimNode.playAnimation(shouldRepeat: false) { [weak self] in
      self?.scoreLblNode?.isHidden = false
      self?.ballAnimNode?.isHidden = false
      self?.starsAnimNode?.isHidden = false
      self?.ballAnimNode?.playAnimation(shouldRepeat: true) {}
      self?.starsAnimNode?.playAnimation(shouldRepeat: false) {}
    }
  }
  
  func prepareFailureAnimation() {
    let width = self.frame.width
    let height = self.frame.height
    let centerScaleFactor = 0.6
    let size = width < height ? (centerScaleFactor*width) : (centerScaleFactor*height)
    let x = bounds.midX//0.2 * width
    let y = bounds.midY //1.2 *
    self.backgroundAnimNode = AnimationNode(size: CGSize(width: size, height: size), position: CGPoint(x: x, y: y), atlasName: SpriteAssets.EndOfExercise.LEVEL_FAILED.rawValue)
    guard let backgroundAnimNode = backgroundAnimNode else {
      return
    }
    self.animationOverlay?.addChild(backgroundAnimNode)
    backgroundAnimNode.playAnimation(shouldRepeat: false) {}
  }
  
  private func addTryAgainButton() {
    guard let calibState = state as? EndOfExerciseState else { return }
    calibState.tryAgainButton = UIButton(frame: .zero)
    self.addSubview(calibState.tryAgainButton!)
    calibState.tryAgainButton?.translatesAutoresizingMaskIntoConstraints = false
    calibState.tryAgainButton?.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant:-24).isActive = true
    calibState.tryAgainButton?.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant:-24).isActive = true
    calibState.tryAgainButton?.setTitle("Play Again (10)", for: .normal)
    calibState.tryAgainButton?.heightAnchor.constraint(equalToConstant: 60).isActive = true
    calibState.tryAgainButton?.widthAnchor.constraint(equalToConstant: 200).isActive = true
    calibState.tryAgainButton?.titleLabel?.font = UIFont(name: "MonoSpec-Medium", size: 18)
    calibState.tryAgainButton?.setTitleColor(ThemeManager.shared.theme.secondaryColor, for: .normal)
    calibState.tryAgainButton?.backgroundColor = ThemeManager.shared.theme.primaryColor
    calibState.tryAgainButton?.layer.cornerRadius = 5
  }
  
  func adjustLabelFontSizeToFitRect(labelNode:SKLabelNode, rect:CGRect) {

//    labelNode.fontSize = 17
    // Determine the font scaling factor that should let the label text fit in the given rectangle.
    let scalingFactor = min(rect.width / labelNode.frame.width, rect.height / labelNode.frame.height)
    
    // Change the fontSize.
    labelNode.fontSize *= scalingFactor
    
    // Optionally move the SKLabelNode to the center of the rectangle.
//    labelNode.position = CGPoint(x: 0, y: -(0.5*(rect.size.width/2)))
  }
  
  public override func cleanup() {
    self.ballAnimNode?.cleanup()
    self.starsAnimNode?.cleanup()
    self.backgroundAnimNode?.cleanup()
    self.scoreLblNode?.removeAllChildren()
    self.scoreLblNode?.removeFromParent()
    self.scoreLblNode = nil
    self.ballAnimNode = nil
    self.starsAnimNode = nil
    self.backgroundAnimNode = nil
    super.cleanup()
  }
    
}
