//
//  CalibrationVisualsView.swift
//  jogo
//
//  Created by Muhammad Nauman on 16/11/2021.
//

import Foundation

class CalibrationVisualsView: LayoutSV {
  
  init(state: CalibrationVisualsState) {
    super.init(state: state, frame: RenderLoop.getFrame()!)
    addTransparency()
    addQuestionMarkButton()
//    self.backgroundColor = .black.withAlphaComponent(0.75)
    RenderLoop.addStaticLayoutStateView(layoutSV: self)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  func addTransparency() {
    let x = ExerciseCalibrationState.LEFT_SCREEN * Double(self.frame.width)
    let y = ExerciseCalibrationState.TOP_SCREEN * Double(self.frame.height)
    let width = (ExerciseCalibrationState.RIGHT_SCREEN - ExerciseCalibrationState.LEFT_SCREEN) * Double(self.frame.width)
    let height = (ExerciseCalibrationState.BOTTOM_SCREEN - ExerciseCalibrationState.TOP_SCREEN) * Double(self.frame.height)
    
    let pathBigRect = UIBezierPath(rect: self.frame)
    let pathSmallRect = UIBezierPath(roundedRect: CGRect(x: x, y: y, width: width, height: height), cornerRadius: 10)

    pathBigRect.append(pathSmallRect)
    pathBigRect.usesEvenOddFillRule = true

    let fillLayer = CAShapeLayer()
    fillLayer.path = pathBigRect.cgPath
    fillLayer.fillRule = .evenOdd
    fillLayer.fillColor = UIColor.black.withAlphaComponent(0.6).cgColor
    self.layer.addSublayer(fillLayer)
  }
  
  func addQuestionMarkButton() {
    guard let calibState = state as? CalibrationVisualsState else { return }
    calibState.questionMarkButton = UIButton(frame: .zero)
    self.addSubview(calibState.questionMarkButton!)
    calibState.questionMarkButton?.translatesAutoresizingMaskIntoConstraints = false
    calibState.questionMarkButton?.topAnchor.constraint(equalTo: self.topAnchor, constant: 24).isActive = true
    calibState.questionMarkButton?.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24).isActive = true
    calibState.questionMarkButton?.widthAnchor.constraint(equalToConstant: 35).isActive = true
    calibState.questionMarkButton?.heightAnchor.constraint(equalToConstant: 35).isActive = true
    calibState.questionMarkButton?.setImage(UIImage(systemName: "questionmark.circle.fill"), for: .normal)
    calibState.questionMarkButton?.tintColor = .yellow
  }
  
}
