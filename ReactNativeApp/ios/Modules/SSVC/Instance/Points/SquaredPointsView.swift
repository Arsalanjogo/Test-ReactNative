//
//  SquaredPointsView.swift
//  jogo
//
//  Created by Mohsin on 13/10/2021.
//

import Foundation
import RxSwift
import UIKit
import Lottie
import SceneKit
import SpriteKit


public class SquaredPointsView: LayoutSV {
  
  // MARK: Setup
  private let disposeBag = DisposeBag()
  
  // MARK: Controls
  private var scoreLabel: SKLabelNode!
  
  // MARK: Sprite Animation
  var scoreAnimNode: AnimationNode!
  var scoreNode: AnimationNode!
  var colorIndicatorAnimNode: AnimationNode!
  var progressBarAnimNode: AnimationNode!
  var powerupAnimNode: AnimationNode!
  private var incrementAnimNode: AnimationNode!
  private var decrementAnimNode: AnimationNode!
  
  // MARK: Constants:
  private let SCORE_ANIM_WIDTH = 0.38
  private let SCORE_ANIM_ASPECT_RATIO = 0.42

  
  // MARK: Constants
  let SCREEN_SIZE = UIScreen.main.bounds
  var X_COORD: Double = 0
  var Y_COORD: Double = 0
  
  init(state: PointsState) {
    super.init(state: state, frame: RenderLoop.getFrame()!)
    
    // Constants:
    self.X_COORD = state.deviceX * self.SCREEN_SIZE.width
    self.Y_COORD = state.deviceY * self.SCREEN_SIZE.height
    
    bindState()
    renderScoreTimerAnimation()
    
    RenderLoop.addStaticLayoutStateView(layoutSV: self)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public func renderScoreTimerAnimation() {
    
    // Set Normalized Positions (Top Left):
    self.scoreAnimNode.position = CGPoint(x: X_COORD, y: Y_COORD)
    
    // Play Animation:
    self.scoreAnimNode.playAnimation(shouldRepeat: false) {}
    
    // Delay for other Animation Nodes:
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
      let exerciseTime = (((GameContext.getContext()?.gameDuration) ?? (TimerState.DEFAULT_GAME_TIME * 1000))/1000)
      
      // Set Normalized Positions (Top Left):
      self.scoreNode.position = CGPoint(x: self.X_COORD, y: self.Y_COORD)
      self.colorIndicatorAnimNode.position = CGPoint(x: self.X_COORD, y: self.Y_COORD)
      self.progressBarAnimNode.position = CGPoint(x: self.X_COORD, y: self.Y_COORD)
      self.powerupAnimNode.position = CGPoint(x: self.X_COORD, y: self.Y_COORD)
      
      // Display Nodes:
      self.hideNodes(nodeState: false)
      
      // Play Animation:
      self.scoreNode.playAnimationImage()
      self.colorIndicatorAnimNode.playAnimationFramesWithTimer(exerciseTime: exerciseTime)
      self.progressBarAnimNode.playAnimationFramesWithTimer(exerciseTime: exerciseTime)
      
      // Remove Node
      self.scoreAnimNode.removeFromParent()
    }
  }
  
  // MARK: Bind to State
  fileprivate func bindState() {
    guard let state = self.state as? PointsState else { return }

    // Score view binding
    state.currentPoints
      .asObservable()
      .map({ String($0) })
      .subscribe(onNext: { [weak self] score in
        guard let strongSelf = self else { return }
                          
        // Animation Logic:
        guard let scoreValue = score.toInt() else { return }
        switch(scoreValue) {
        case 0...10:
            strongSelf.powerupAnimNode.playAnimationFrames(fromFrame: 0, toFrame: 1)
        case 11...20:
            strongSelf.powerupAnimNode.playAnimationFrames(fromFrame: 1, toFrame: 2)
        case 21...30:
            strongSelf.powerupAnimNode.playAnimationFrames(fromFrame: 2, toFrame: 3)
        case 31...40:
            strongSelf.powerupAnimNode.playAnimationFrames(fromFrame: 3, toFrame: 4)
        case 41...50:
            strongSelf.powerupAnimNode.playAnimationFrames(fromFrame: 4, toFrame: 5)
        case 51...60:
            strongSelf.powerupAnimNode.playAnimationFrames(fromFrame: 5, toFrame: 6)
        default:
            return
        }
        
        // Score Label Props:
        strongSelf.scoreLabel.text = score
        strongSelf.scoreLabel.fontColor = .yellow
        strongSelf.scoreLabel.zPosition = 3
        strongSelf.scoreLabel.position = CGPoint(x: -(0.3 * strongSelf.scoreNode.size.width), y: -(0.1 * strongSelf.scoreNode.size.height))
      })
      .disposed(by: disposeBag)
    
    state.lastPoint
      .asObservable()
      .subscribe(onNext: { [weak self] point in
        guard let strongSelf = self else { return }
        
        // Render Animation
        // If True; Render Decrement Animation else Increment Animation
        let normalizedHeight = strongSelf.SCREEN_SIZE.height - point.0.getY() * strongSelf.SCREEN_SIZE.height
        if point.1 {
          // Get Ball Location:
          strongSelf.decrementAnimNode.position = CGPoint(x: point.0.getX() * strongSelf.SCREEN_SIZE.width, y: normalizedHeight)
          strongSelf.decrementAnimNode.playAnimation(shouldRepeat: false) { }
        } else {
          // Get Ball Location:
          strongSelf.incrementAnimNode.position = CGPoint(x: point.0.getX() * strongSelf.SCREEN_SIZE.width, y: normalizedHeight)
          strongSelf.incrementAnimNode.playAnimation(shouldRepeat: false) { }
        }
        
      })
      .disposed(by: disposeBag)    
  }
    
  override func prepareAnimation() {
    
    // Properties:
    let width = SCORE_ANIM_WIDTH * self.bounds.width
    let height = SCORE_ANIM_ASPECT_RATIO * width
    let animSize = CGSize(width: width, height: height)
    
    // Animation Nodes:
    self.incrementAnimNode = AnimationNode(size: CGSize(width: 40, height: 40), position: center, atlasName: SpriteAssets.Score.INCREMENT.rawValue)
    self.decrementAnimNode = AnimationNode(size: CGSize(width: 40, height: 40), position: center, atlasName: SpriteAssets.Score.DECREMENT.rawValue)
    self.scoreAnimNode = AnimationNode(size: animSize, position: CGPoint(x: 0, y: 0), atlasName: SpriteAssets.Score.SCORE_TIMER_ANIM.rawValue)
    self.scoreNode = AnimationNode(size: animSize, position: CGPoint(x: 0, y: 0), atlasName: SpriteAssets.Score.SCORE_TIMER.rawValue)
    self.colorIndicatorAnimNode = AnimationNode(size: animSize, position: CGPoint(x: 0, y: 0), atlasName: SpriteAssets.Score.COLOR.rawValue)
    self.progressBarAnimNode = AnimationNode(size: animSize, position: CGPoint(x: 0, y: 0), atlasName: SpriteAssets.Score.PROGRESS_BAR.rawValue)
    self.powerupAnimNode = AnimationNode(size: animSize, position: CGPoint(x: 0, y: 0), atlasName: SpriteAssets.Score.POWER.rawValue)
    self.scoreLabel = SKLabelNode(fontNamed: "MonoSpec-Medium")
    
    // Hide Nodes before Render:
    hideNodes(nodeState: true)
    
    self.animationOverlay?.addChild(self.scoreAnimNode)
    self.animationOverlay?.addChild(self.scoreNode)
    self.scoreNode.addChild(self.scoreLabel)
    self.animationOverlay?.addChild(self.colorIndicatorAnimNode)
    self.animationOverlay?.addChild(self.progressBarAnimNode)
    self.animationOverlay?.addChild(self.powerupAnimNode)
    self.animationOverlay?.addChild(self.incrementAnimNode)
    self.animationOverlay?.addChild(self.decrementAnimNode)
  }
  
  private func hideNodes(nodeState: Bool) {
    self.scoreNode.isHidden = nodeState
    self.colorIndicatorAnimNode.isHidden = nodeState
    self.progressBarAnimNode.isHidden = nodeState
    self.powerupAnimNode.isHidden = nodeState
  }
  
  public override func cleanup() {
    self.scoreAnimNode?.cleanup()
    self.scoreAnimNode = nil
    self.scoreNode?.cleanup()
    self.scoreNode = nil
    self.scoreLabel = nil
    self.colorIndicatorAnimNode?.cleanup()
    self.colorIndicatorAnimNode = nil
    self.progressBarAnimNode?.cleanup()
    self.progressBarAnimNode = nil
    self.powerupAnimNode?.cleanup()
    self.powerupAnimNode = nil
    self.incrementAnimNode?.cleanup()
    self.incrementAnimNode = nil
    self.decrementAnimNode?.cleanup()
    self.decrementAnimNode = nil
    
    super.cleanup()
  }
  
}


// MARK: Extensions
extension String {
  public func toInt() -> Int? {
    if let num = NumberFormatter().number(from: self) {
      return num.intValue
    } else {
      return nil
    }
  }
}
