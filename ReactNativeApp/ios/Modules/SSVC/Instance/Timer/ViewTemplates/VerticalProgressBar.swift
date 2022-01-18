//
//  VerticalProgressBar.swift
//  jogo
//
//  Created by Mohsin on 30/11/2021.
//

import Foundation
import UIKit

@IBDesignable class VerticalProgressBar: UIView {
    
  @IBInspectable public var animationDuration = 0.95
    
  var previousProgress: Float = 0.0
  
  var color: UIColor = .green
  
  @IBInspectable public var progress: Float {
    get {
      return self.previousProgress
    }
    set {
      self.setProgress(progress: newValue, animated: self.animationDuration > 0.0)
    }
  }
  
  public var filledView: CALayer?
    
  override public func draw(_ rect: CGRect) {
    super.draw(rect)
    let filledHeight = rect.size.height * CGFloat(self.previousProgress)
    let y = self.frame.size.height - filledHeight
    self.filledView!.frame = CGRect(x: 0, y: y, width: rect.size.width, height: rect.size.height)
  }

  public override func layoutSubviews() {
    super.layoutSubviews()
    if self.filledView == nil {
      self.filledView = CALayer()
      self.filledView!.backgroundColor = color.cgColor
      self.layer.addSublayer(filledView!)
    }
    self.filledView!.frame = self.bounds
    self.filledView!.frame.origin.y = self.getPosition()
  }
    
  public override func prepareForInterfaceBuilder() {
    self.previousProgress = progress
    if previousProgress < 0 {
      previousProgress = 0
    } else if previousProgress > 1 {
      previousProgress = 1
    }
  }
    
  public func setProgress(progress: Float, animated: Bool) {
    var value = progress
    if value < 0.0 {
      value = 0.0
    } else if value > 1.0 {
      value = 1.0
    }
    self.previousProgress = value
    setFilledProgress(position: getPosition(), animated: animated)
  }
    
  fileprivate func setFilledProgress(position: CGFloat, animated: Bool) {
    if filledView == nil { return }
    // Animation
    let duration: TimeInterval = animated ? self.animationDuration : 0
    CATransaction.begin()
    CATransaction.setAnimationDuration(duration)
    filledView!.frame.origin.y = position
    filledView!.backgroundColor = color.cgColor
    CATransaction.commit()
  }
    
  fileprivate func getPosition() -> CGFloat {
    let filledHeight = self.frame.size.height * CGFloat(self.previousProgress)
    let position = self.frame.size.height - filledHeight
    return position
  }
}
