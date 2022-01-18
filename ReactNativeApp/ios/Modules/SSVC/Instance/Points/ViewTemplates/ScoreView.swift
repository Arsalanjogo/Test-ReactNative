//
//  ScoreView.swift
//  jogo
//
//  Created by Muhammad Nauman on 28/11/2020.
//

import UIKit
import AVFoundation
import QuartzCore

class ScoreView: UIView {
  // Holds all the score related views in a single object.
  // Timer View, Score Text, Content View.
  // Sound player for any sound related to the scoring mechanism.
  
//  @IBOutlet private weak var timerLbl: Chronometer! // Handles all timer functionality.
//  @IBOutlet private weak var timerView: UIView!
//  @IBOutlet private weak var timeTitleLbl: UILabel!
  @IBOutlet private weak var scoreLbl: UILabel! // Score text view
  @IBOutlet private weak var scoreView: UIView!
  @IBOutlet private weak var scoreTitleLbl: UILabel!
  @IBOutlet private var contentView: UIView! // Just a simple view
  
  private var soundID: SystemSoundID? // Id of the sound
  private var audioPlayer: AVAudioPlayer!
  
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
    Bundle.main.loadNibNamed("ScoreView", owner: self, options: nil)
    contentView.fixInView(self)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    let width = self.scoreLbl.frame.width
    self.scoreLbl.layer.cornerRadius = width / 2.0
    self.scoreLbl.clipsToBounds = true
    self.scoreLbl.font = UIFont(name: "MonoSpec-Medium", size: self.scoreLbl.font.pointSize)
    self.scoreTitleLbl.font = self.scoreTitleLbl.font.boldItalicMono
  }
  
  // MARK: Properties Get/Set
  func setCount(score: String, blink: Bool) {
    var scoreText = score
    if score.count == 1 {
      scoreText = "0\(score)"
    }
    guard blink else {
      DispatchQueue.main.async {
        self.scoreLbl.text = scoreText
      }
      return
    }
    DispatchQueue.main.async { [weak self] in
      self?.scoreLbl.layer.removeAllAnimations()
      self?.scoreLbl.text = scoreText
    }
  }
  
//  func updateTime(time: String) {
//    self.timerLbl.text = time
//  }
//
  func updateScoreView() {
  }
  
  // MARK: Sound
  func playBeepSound() {
    audioPlayer.currentTime = 0
    audioPlayer.play()
  }
  
  // MARK: UI Component Getters
  
//  func getTimer() -> Chronometer? {
//    return self.timerLbl
//  }
  
//  func getTimerView() -> UIView {
//    return self.timerView
//  }
  
  func getScoreLabel() -> UILabel {
    return scoreLbl
  }
  
  func getScoreView() -> UIView {
    return scoreView
  }
  
}

extension UIView {
  func fixInView(_ container: UIView!) {
    self.translatesAutoresizingMaskIntoConstraints = false
    self.frame = container.frame
    container.addSubview(self)
    NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
    NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
    NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
    NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
  }
}
