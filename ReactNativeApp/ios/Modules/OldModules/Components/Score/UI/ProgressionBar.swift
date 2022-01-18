//
//  ProgressionBar.swift
//  jogo
//
//  Created by Muhammad Nauman on 13/09/2021.
//

import UIKit

class ProgressionBar: UIView {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var levelLbl: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
  
  //MARK: Lifecycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }
  
  func commonInit() {
    Bundle.main.loadNibNamed("ProgressionBar", owner: self, options: nil)
    contentView.fixInView(self)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    mainView.layer.cornerRadius = 20
    // Set the rounded edge for the outer bar
    progressBar.layer.cornerRadius = 12
    progressBar.clipsToBounds = true

    //Set the rounded edge for the inner bar
    progressBar.layer.sublayers![1].cornerRadius = 12
    progressBar.subviews[1].clipsToBounds = true
  }
  
  func setProgress(value: Float) {
    let roundedValue = ((value * 100).rounded()) / 100
    print(roundedValue)
    DispatchQueue.main.async {
      UIView.animate(withDuration: 0.25) {
        self.progressBar.setProgress(roundedValue, animated: true)
        if self.progressBar.progress < 0.3 {
          self.progressBar.progressTintColor = .red.withAlphaComponent(0.8)
        } else if self.progressBar.progress < 0.6 {
          self.progressBar.progressTintColor = .orange.withAlphaComponent(0.8)
        } else{
          self.progressBar.progressTintColor = ThemeManager.shared.theme.primaryColor.withAlphaComponent(0.8)
        }
      }
    }
  }
}
