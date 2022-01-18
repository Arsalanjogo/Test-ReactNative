//
//  TimerViewTemplate.swift
//  jogo
//
//  Created by Mohsin on 29/11/2021.
//

import UIKit

class TimerViewTemplate: UIView {

  @IBOutlet weak var timerContainer: UIView!
  @IBOutlet weak var timerTitleLabel: UILabel!
  @IBOutlet weak var timerLabel: UILabel!
  
  // MARK: Lifecycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }
  
  func commonInit() {
    Bundle.main.loadNibNamed("TimerViewTemplate", owner: self, options: nil)
    timerContainer.fixInView(self)
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    self.timerLabel.font = UIFont(name: "MonoSpec-Medium", size: self.timerLabel.font.pointSize)
    self.timerTitleLabel.font = self.timerTitleLabel.font.boldItalicMono
  }
}
