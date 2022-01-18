//
//  StopRestartView.swift
//  Football433
//
//  Created by Muhammad Nauman on 15/12/2021.
//

import Foundation
import UIKit

public class StopRestartView: LayoutSV {
  
  var stopBtn: UIButton?
  var restartBtn: UIButton?
  
  init(state: StopRestartState) {
    super.init(state: state, frame: RenderLoop.getFrame()!)
    self.addStopButton()
    self.addRestartButton()
    RenderLoop.addStaticLayoutStateView(layoutSV: self)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  @objc func stopBtnAction(_ sender: UIButton){
    (self.state as? StopRestartState)?.state = .STOP
  }
  
  @objc func restartBtnAction(_ sender: UIButton){
    (self.state as? StopRestartState)?.state = .RESTART
  }
  
  func addStopButton() {
    self.stopBtn = UIButton(frame: .zero)
    self.addSubview(self.stopBtn!)
    self.stopBtn?.translatesAutoresizingMaskIntoConstraints = false
    self.stopBtn?.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -24).isActive = true
    self.stopBtn?.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24).isActive = true
    self.stopBtn?.widthAnchor.constraint(equalToConstant: 100).isActive = true
    self.stopBtn?.heightAnchor.constraint(equalToConstant: 60).isActive = true
    self.stopBtn?.setTitle("STOP", for: .normal)
    self.stopBtn?.backgroundColor = .red
    self.stopBtn?.layer.cornerRadius = 5
    self.stopBtn?.setTitleColor(ThemeManager.shared.theme.secondaryColor, for: .normal)
    self.stopBtn?.titleLabel?.font = UIFont(name: "MonoSpec-Medium", size: 18)
    self.stopBtn?.addTarget(self, action: #selector(stopBtnAction(_:)), for: .touchUpInside)
  }
  
  func addRestartButton() {
    self.restartBtn = UIButton(frame: .zero)
    self.addSubview(self.restartBtn!)
    self.restartBtn?.translatesAutoresizingMaskIntoConstraints = false
    self.restartBtn?.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -24).isActive = true
    self.restartBtn?.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24).isActive = true
    self.restartBtn?.widthAnchor.constraint(equalToConstant: 120).isActive = true
    self.restartBtn?.heightAnchor.constraint(equalToConstant: 60).isActive = true
    self.restartBtn?.setTitle("RESTART", for: .normal)
    self.restartBtn?.backgroundColor = ThemeManager.shared.theme.primaryColor
    self.restartBtn?.layer.cornerRadius = 5
    self.restartBtn?.setTitleColor(ThemeManager.shared.theme.secondaryColor, for: .normal)
    self.restartBtn?.titleLabel?.font = UIFont(name: "MonoSpec-Medium", size: 18)
    self.restartBtn?.addTarget(self, action: #selector(restartBtnAction(_:)), for: .touchUpInside)
  }
  
  public override func cleanup() {
    self.stopBtn?.removeFromSuperview()
    self.restartBtn?.removeFromSuperview()
    self.stopBtn = nil
    self.restartBtn = nil
    super.cleanup()
  }
  
}
