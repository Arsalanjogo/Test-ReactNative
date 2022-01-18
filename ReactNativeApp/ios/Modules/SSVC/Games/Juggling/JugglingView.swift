//
//  JugglingView.swift
//  jogo
//
//  Created by arham on 18/11/2021.
//

import Foundation


class JugglingView: BaseGameView {
  
  init(state: JugglingState) {
    super.init(state: state)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func draw(canvas: UIView) {
    drawThresholds(canvas: canvas)
  }
  
  func drawThresholds(canvas: UIView) {
    guard let state = (self.state as? JugglingState) else { return }
    DrawingManager.get().drawLineOnY(view: canvas, y: state.kneeLine ?? 0, color: .red)
    DrawingManager.get().drawLineOnY(view: canvas, y: state.groundLine ?? 1, color: .blue)
  }
}
