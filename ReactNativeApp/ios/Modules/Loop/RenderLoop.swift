//
//  RenderLoop.swift
//  jogo
//
//  Created by Mohsin on 12/10/2021.
//

import Foundation
import UIKit
import SceneKit


final public class RenderLoop: SCNView {
  
  private static var render: RenderLoop?
  
  private static let MAX_FPS = 60.0
  private static let MAX_FRAME_TIME: Double = 1.0 / MAX_FPS
  private static let LOGTAG: String = "RenderLoop"
  public var layoutStateViews: [LayoutSV] = []
  public var dynamicStateViews: [DynamicSV] = []
  
  private var drawTimer: Timer?
  private var drawingActive: Bool = false
  
  private let drawingView = UIView()
  private let uiView = UIView()
  var spriteScene: AnimationOverlay?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    drawingView.frame = frame
    uiView.frame = frame
    self.addSubview(drawingView)
    self.addSubview(uiView)
    
    // Initialising scene
    self.scene = SCNScene()
    self.scene?.background.contents = UIColor.clear
    self.backgroundColor = .clear
    
    self.spriteScene = AnimationOverlay(size: bounds.size, prepareAnimation: nil)
    self.overlaySKScene = self.spriteScene
    
    guard RenderLoop.render != nil else {
      RenderLoop.render = self
      return
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override init(frame: CGRect, options: [String : Any]? = nil) {
    super.init(frame: frame, options: options)
  }
  
  public static func cleanup() {
    RenderLoop.render = nil
  }
  
  public func start() {
    self.startDrawThread()
  }

  public static func removeLayoutStateView(layoutSV: LayoutSV) {
//    guard render != nil else { return }
//    _ = render!.uiView.subviews.filter { !($0 == layoutSV) }
    layoutSV.removeFromSuperview()
  }
  
  public static func addStaticLayoutStateView(layoutSV: LayoutSV) {
    render!.uiView.addSubview(layoutSV)
  }
  
  public static func assignNewScene(skScene: AnimationOverlay) {
    render!.spriteScene = skScene
    render!.overlaySKScene = skScene
  }
  
  public static func removeCurrentScene() {
    render?.spriteScene?.cleanup()
    render?.spriteScene = nil
    render?.overlaySKScene = nil
  }
  
  public static func removeDynamicStateView(dynamicSV: DynamicSV) {
    guard render != nil else { return }
    render!.dynamicStateViews = render!.dynamicStateViews.filter { !($0 == dynamicSV) }
  }
  
  public static func addDynamicStateView(dynamicSV: DynamicSV) {
    render?.dynamicStateViews.append(dynamicSV)
  }
  
  public static func getSpriteScene() -> AnimationOverlay? {
    return render?.spriteScene
  }
  
  public func startDrawThread() {
    if drawTimer == nil {
      drawingActive = true
      drawTimer = Timer(timeInterval: RenderLoop.MAX_FRAME_TIME, repeats: true) { [weak self] _ in
//        Logger.shared.log(logType: .DEBUG, message: "RL Instance")
        DispatchQueue.main.async {
          self?.run()
        }
      }
      RunLoop.current.add(drawTimer!, forMode: .common)
    }
  }
  
  public func stopDrawThread() {
    guard self.drawTimer != nil else {
      Logger.shared.logError(text: "Drawing Thread is already deleted")
      return
    }
    drawingActive = false
    while true {
      do {
        drawTimer?.invalidate()
        break
      } catch {
        Logger.shared.logError(text: "Queue and timer was not able to be invalidated.")
      }
    }
    drawTimer = nil
    self.layoutStateViews.removeAll()
    self.dynamicStateViews.removeAll()
    self.drawingView.removeFromSuperview()
    self.uiView.removeFromSuperview()
  }
  
  public func run() {
    setNeedsDisplay()
    self.draw(self.frame)
  }
  
  static func getFrame() -> CGRect? {
    return render?.frame
  }
  
  func removeLayers(canvas: UIView) {
      canvas.layer.sublayers?.removeAll()
  }
  
  public override func draw(_ rect: CGRect) {
    let startFrameTime: Double = Date().getMilliseconds()
    
    removeLayers(canvas: self.drawingView)
    
    dynamicStateViews.forEach { layout in
      layout.draw(canvas: self.drawingView)
    }
    let endFrameTime: Double = Date().getMilliseconds()
//    Logger.shared.log(logType: .DEBUG, message: "\(endFrameTime - startFrameTime) ms" )
    super.draw(rect)
  }
}
