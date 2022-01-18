//
//  ExerciseRenderView.swift
//  jogo
//
//  Created by Muhammad Nauman on 22/03/2021.
//

import UIKit

class ExerciseRenderView: UIView {
  // Holds the linking and logic for the ERM for views used across the exercises.
  
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var stopBtn: UIButton!
  @IBOutlet private weak var restartBtn: UIButton!
  @IBOutlet private weak var textLabel: UILabel!
  @IBOutlet private var contentView: UIView!
  var scoreView: ScoreView!
//  internal var progressionBar: ProgressionBar!
  internal var graphContainer: UIView!
  
  var orientation: ExerciseViewController.ExerciseOrientation = .landscape
  private var activated: Bool = false
  private let activateTime: Double = 4000
  private var activationTime: Double?
  
  init(frame: CGRect, eorientation: ExerciseViewController.ExerciseOrientation) {
    super.init(frame: frame)
    orientation = eorientation
    commonInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }
  
  public func activate() {
    if !self.activated {
      self.activated = true
      self.stopBtn?.isHidden = false
      if (BaseExercise.getExercise()?.status ?? .NOT_STARTED) == .EXERCISE {
        self.restartBtn?.isHidden = false
      }
      self.activationTime = Date().getMilliseconds()
    }
  }
  
  public func deactivate(immediate: Bool = false) {
    if self.activated {
      if Date().getMilliseconds() - self.activationTime! > self.activateTime {
        self.activated = false
        self.stopBtn?.isHidden = true
        self.restartBtn?.isHidden = true
      }
    }
  }
  
  func onlyTimerView() {
    self.scoreView.getScoreLabel().isHidden = true
  }
  
  private func commonInit() {
    Bundle.main.loadNibNamed("ExerciseRenderView", owner: self, options: nil)
    contentView.fixInView(self)
    stopBtn.layoutIfNeeded()
    restartBtn.layoutIfNeeded()
//    progressionBar = ProgressionBar(frame: CGRect.zero)
//    progressionBar.translatesAutoresizingMaskIntoConstraints = false
//    contentView.addSubview(progressionBar)
//    progressionBar.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
//    progressionBar.widthAnchor.constraint(equalToConstant: 0.9*(contentView.frame.width - 2*stopBtn.frame.width)).isActive = true
//    progressionBar.heightAnchor.constraint(equalToConstant: 70).isActive = true
////    progressionBar.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.1).isActive = true
//    progressionBar.centerYAnchor.constraint(equalTo: stopBtn.centerYAnchor).isActive = true
    if UIDevice.current.userInterfaceIdiom == .pad {
      scoreView = ScoreView(frame: CGRect(x: contentView.frame.width-188-16, y: 8, width: 188, height: 260))
    } else {
      scoreView = ScoreView(frame: CGRect(x: contentView.frame.width-156-16, y: 8, width: 156, height: 216))
    }
    contentView.addSubview(scoreView)
    contentView.bringSubviewToFront(stopBtn)
    scoreView.layoutIfNeeded()
//    progressionBar.layoutIfNeeded()

    //Graph
    graphContainer = UIView(frame: .zero)
//    graphContainer.frame = CGRect(x: 0, y: 56, width: 200, height: 170)
    graphContainer.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(graphContainer)
    graphContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
    graphContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 64).isActive = true
    graphContainer.widthAnchor.constraint(equalToConstant: 0.19*contentView.frame.width).isActive = true
    graphContainer.heightAnchor.constraint(equalToConstant: 0.24*contentView.frame.height).isActive = true
    graphContainer.isHidden = true
    graphContainer.layoutIfNeeded()
    
    activityIndicator.isHidden = true
  }
  
  // MARK: UI Object Getters
  
  public func getStopBtn() -> UIButton {
    return stopBtn
  }
  
  public func getRestartBtn() -> UIButton {
    return restartBtn
  }
  
  public func getTextLbl() -> UILabel {
    return textLabel
  }
  
  public func getContentView() -> UIView {
    return contentView
  }
  
}
