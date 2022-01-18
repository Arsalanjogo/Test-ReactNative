//
//  LottieBase.swift
//  jogo
//
//  Created by Admin on 19/05/2021.
//

import UIKit
import Lottie

class LottieBase<T: AnyObject>: LottieProtocol {
  typealias NoArgMethod = () -> Void
  
  final var exerciseViewController: ExerciseViewController
  final var renderView: ExerciseRenderView
  var lottieAnimationView: AnimationView
  private var ephemeral = true
  private var running = false
  private var minFrame: CGFloat?
  private var maxFrame: CGFloat?
  private var targetView: UIView?
  public var animationName: String
  private var didStart: [NoArgMethod]? = []
  private var didEnd: [NoArgMethod]? = []
  private var didCancel: [NoArgMethod]? = []
    
  init(exerciseVC: ExerciseViewController, animationName: String, targetView: UIView?) {
    self.exerciseViewController = exerciseVC
    self.renderView = exerciseVC.exerciseRenderView
    self.targetView = targetView
    self.animationName = animationName
    lottieAnimationView = AnimationView(animation: Animation.named(animationName), imageProvider: BundleImageProvider(bundle: Bundle(for: LottieRender.self), searchPath: nil))
    if let target = targetView, let parentView = targetView?.superview {
      parentView.addSubview(lottieAnimationView)
      parentView.sendSubviewToBack(lottieAnimationView)
      let targetSize = target.frame.size
      lottieAnimationView.frame.size = CGSize(width: targetSize.width, height: targetSize.height)
      lottieAnimationView.center = target.center
    } else {
      renderView.addSubview(lottieAnimationView)
      renderView.sendSubviewToBack(lottieAnimationView)
      lottieAnimationView.frame = renderView.bounds
    }
    self.lottieAnimationView.contentMode = .scaleToFill
    LottieManager.get().insert(animation: self, animationName: animationName)
  }
  
  func runningCheck() throws {
    if running && ephemeral {
      throw RuntimeError("Cannot set methods on ephemeral animation after running")
    }
  }
  
  func ephemeral(ephemeral: Bool) throws -> T {
    try runningCheck()
    self.ephemeral = ephemeral
    return self as! T
  }
  
  func stop() {
    self.lottieAnimationView.stop()
    self.lottieAnimationView.isHidden = true
  }
  
  func contentMode(mode: UIView.ContentMode) throws -> T {
    try runningCheck()
    self.lottieAnimationView.contentMode = mode
    return self as! T
  }
  
  func minFrame(minFrame: CGFloat) throws -> T {
    try runningCheck()
    self.minFrame = minFrame
    return self as! T
  }
  
  func maxFrame(maxFrame: CGFloat) throws -> T {
    try runningCheck()
    self.maxFrame = maxFrame
    return self as! T
  }
  
  func background(color: UIColor) throws -> T {
    try runningCheck()
    self.lottieAnimationView.backgroundColor = color
    return self as! T
  }
  
  func move(x: CGFloat, y: CGFloat) throws -> T {
    try runningCheck()
    let actualX = renderView.frame.width * x
    let actualY = renderView.frame.height * y
    self.lottieAnimationView.center = CGPoint(x: actualX, y: actualY)
    return self as! T
  }
  
  func scale(x: CGFloat, y: CGFloat) throws -> T {
    try runningCheck()
    let width = renderView.frame.width * x
    let height = renderView.frame.height * y
    self.lottieAnimationView.frame.size = CGSize(width: width, height: height)
    return self as! T
  }
  
  func play() throws {
    _ = try? self.play(loopMode: .playOnce, completion: nil)
  }
  
  func play(loopMode: LottieLoopMode = .playOnce, completion: NoArgMethod? = nil) throws -> T {
    if let target = self.targetView, target.isHidden {
      return self as! T
    }
    try runningCheck()
    didStart?.forEach { (method) in
      method()
    }
    if let min = minFrame, let max = maxFrame {
      self.lottieAnimationView.play(fromFrame: min, toFrame: max, loopMode: loopMode) { [weak self] (completed) in
        if completed {
          completion?()
          self?.didEnd?.forEach { (method) in
            method()
          }
        } else {
          self?.didCancel?.forEach({ (method) in
            method()
          })
        }
      }
    } else {
      self.lottieAnimationView.loopMode = loopMode
      self.lottieAnimationView.play { [weak self] (completed) in
        if completed {
          completion?()
          self?.didEnd?.forEach { (method) in
            method()
          }
        } else {
          self?.didCancel?.forEach({ (method) in
            method()
          })
        }
      }
    }
    
    return self as! T
  }
  
  func onStart(method: @escaping NoArgMethod) throws -> T {
    try runningCheck()
    self.didStart?.append(method)
    return self as! T
  }
  
  func onStop(method: @escaping NoArgMethod) throws -> T {
    try runningCheck()
    self.didEnd?.append(method)
    return self as! T
  }
  
  func onCancel(method: @escaping NoArgMethod) throws -> T {
    try runningCheck()
    self.didCancel?.append(method)
    return self as! T
  }
  
  private func cleanup() {
    lottieAnimationView.removeFromSuperview()
  }
  
  func delete() throws -> T {
    try runningCheck()
    self.cleanup()
    return self as! T
  }
  
  func speed(value: CGFloat) throws -> T {
    try runningCheck()
    self.lottieAnimationView.animationSpeed = value
    return self as! T
  }
  
  func clearDidStart() {
    self.didStart?.removeAll()
    self.didStart = nil
  }
  
  func clearDidEnd() {
    self.didEnd?.removeAll()
    self.didEnd = nil
  }
  
  func clearDidCancel() {
    self.didCancel?.removeAll()
    self.didCancel = nil
  }
  
  func tag() -> String {
    return self.animationName
  }
  
  deinit {
    Logger.shared.log(logType: .DEBUG, message: "Lottie deinited...")
  }
  
}
