//
//  TimerView.swift
//  jogo
//
//  Created by Mohsin on 27/10/2021.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit
import Lottie

public class TimerView: LayoutSV {
  
  // MARK: Setup
  private let disposeBag = DisposeBag()
  private var countdownAnimationPlayed = false
  
  // MARK: Controls
  private var timerView: TimerViewTemplate!
  private var progressBar: VerticalProgressBar!
  private var countdownAnimation: AnimationView!
  
  
  init(state: TimerState) {
    super.init(state: state, frame: RenderLoop.getFrame()!)
    state.progressBarLength = 0.7
    setupViews()
    bindState()
    RenderLoop.addStaticLayoutStateView(layoutSV: self)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  private func getColorBySecondsRemaining(seconds: Double) -> UIColor {
    switch seconds {
    case let x where x <= 5:
      return UIColor.red
    case let x where x <= 15:
      return UIColor.purple
    default:
      return UIColor.yellow
    }
  }
  
  fileprivate func bindState() {
    guard let state = self.state as? TimerState else { return }
    
    // Time Text binding
    state.timerText
      .asObservable()
      .bind(to: timerView.timerLabel.rx.text)
      .disposed(by: disposeBag)
    
    // Progress bar length and all views color change binding
    state.timeProgressPercentage
      .asObservable()
      .map({ Float($0) })
      .subscribe(onNext: { [unowned self] progress in
        // FIXME: Refactor this shitty magic number workaround
        if progress < 0.002 {
          self.progressBar.setProgress(progress: 0, animated: false)
        } else {
          self.progressBar.color = getColorBySecondsRemaining(
            seconds: state.gameTime - state.elapsedSeconds
          )
          self.timerView.timerLabel.textColor = getColorBySecondsRemaining(
            seconds: state.gameTime - state.elapsedSeconds
          )
          self.progressBar.setProgress(progress: progress, animated: false)
        }
      })
      .disposed(by: disposeBag)
    
    // 5 seconds remaining binding
    state.timerText
      .asObservable()
      .map({ Int($0.replacingOccurrences(of: ":", with: ""))! })
      .subscribe(onNext: { [weak self] timeRemaining in
        guard let strongSelf = self else { return }
        if timeRemaining == 5 && !strongSelf.countdownAnimationPlayed {
          strongSelf.countdownAnimationPlayed = true
          strongSelf.addSubview(strongSelf.countdownAnimation)
          strongSelf.countdownAnimation.play(
            fromFrame: 0,
            toFrame: 180,
            loopMode: .playOnce,
            completion: { _ in
              strongSelf.countdownAnimation.stop()
              strongSelf.countdownAnimation.removeFromSuperview()
            }
          )
        }
      })
      .disposed(by: disposeBag)
    
  }
  
}


// MARK: Setup Views
extension TimerView {
  fileprivate func setupViews() {
    let screen = UIScreen.main.bounds
    
    // Timer Text
    timerView = TimerViewTemplate(frame: CGRect(x: self.frame.width - 140 - 16, y: 8, width: 140, height: 55))
    self.addSubview(timerView)
    
    // Progress Bar
    progressBar = VerticalProgressBar()
    progressBar.translatesAutoresizingMaskIntoConstraints = false
    progressBar.clipsToBounds = true
    progressBar.color = .red
    self.addSubview(progressBar)
    progressBar.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
    progressBar.topAnchor.constraint(equalTo: self.topAnchor, constant: 75).isActive = true
    progressBar.widthAnchor.constraint(equalToConstant: 10).isActive = true
    progressBar.heightAnchor.constraint(equalToConstant: screen.height - 75 - 20).isActive = true
    progressBar.setProgress(progress: 1.0, animated: false)
    
    // Countdown animation
    countdownAnimation = AnimationView(animation: Animation.named(LottieMapping.Counters.countdown_5_seconds.rawValue))
    countdownAnimation.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
    countdownAnimation.center = self.center
    countdownAnimation.contentMode = .scaleAspectFit
  }
}
