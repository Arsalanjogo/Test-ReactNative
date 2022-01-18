//
//  ExerciseCalibrationView.swift
//  jogo
//
//  Created by Mohsin on 21/10/2021.
//

import Foundation

public class ExerciseCalibrationView: DynamicSV {
  
  var _state: ExerciseCalibrationState!
  
  init(state: ExerciseCalibrationState) {
    super.init(state: state, frame: RenderLoop.getFrame()!)
    _state = state
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override func draw(canvas: UIView) {
    super.draw(canvas: canvas)
//    GameContext.getContext()!.objectDetections.forEach({ $0.draw(canvas: canvas) })
//    _state.detections.forEach({ $0.draw(canvas: canvas) })
  }
}
