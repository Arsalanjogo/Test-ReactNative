//
//  LottieCountdown.swift
//  jogo
//
//  Created by Muhammad Nauman on 22/05/2021.
//

import Foundation

class LottieCountdown: LottieBase<LottieCountdown> {
  
  var countDown: LottieRender?
  var gameHeading: LottieRender?
  var countDownSound: SoundRender?
  var exerciseDescriptionLbl: UILabel?
  
  init(exerciseVC: ExerciseViewController) {
    countDownSound = SoundRender(value: SoundMapping.Score.Count_Down.Asset)
    countDown = try? LottieRender(exerciseVC: exerciseVC, animationName: LottieMapping.Opening.countdown.rawValue).contentMode(mode: .scaleAspectFit).move(x: 0.75, y: 0.5)
    gameHeading = LottieRender(exerciseVC: exerciseVC, animationName: LottieMapping.GameText.game.rawValue)
    super.init(exerciseVC: exerciseVC, animationName: LottieMapping.Background.green_in_out.rawValue, targetView: nil)
    let height = renderView.frame.height * 0.15
    gameHeading?.lottieAnimationView.frame.size = CGSize(width: height * 1.25, height: height)
    gameHeading = try? gameHeading?.move(x: 0.15, y: 0.2)
    let gameFrame = gameHeading!.lottieAnimationView.frame
    let countDownFrame = countDown!.lottieAnimationView.frame
    let y = gameFrame.origin.y + gameFrame.height + 8
    exerciseDescriptionLbl = UILabel(frame: CGRect(x: gameFrame.origin.x,
                                                   y: y,
                                                   width: (1.5 * countDownFrame.origin.x) - gameFrame.origin.x,
                                                   height: renderView.frame.height - y))
    exerciseDescriptionLbl?.font = UIFont.systemFont(ofSize: 28, weight: .semibold)
    exerciseDescriptionLbl?.numberOfLines = 0
    exerciseDescriptionLbl?.text = exerciseVC.exerciseSettings?.getDescription()
    exerciseDescriptionLbl?.sizeToFit()
    exerciseDescriptionLbl?.textColor = .white
    exerciseDescriptionLbl?.isHidden = true
    renderView.addSubview(exerciseDescriptionLbl!)
    gameHeading?.lottieAnimationView.isHidden = true
    _ = try? self.minFrame(minFrame: 1.0).maxFrame(maxFrame: 40.0).onStart {
      self.renderView.scoreView.isHidden = true
    }
  }
  
  override func play() {
    self.renderView.getTextLbl().isHidden = true
     _ = try? self.play(completion: { [weak self] in
      guard self != nil else { return }
      self?.playCountdownCombined()
      self?.playGameHeading()
    })
  }
  
  private func playGameHeading() {
    gameHeading?.lottieAnimationView.isHidden = false
    _ = try? self.gameHeading?.play(completion: { [weak self] in
      self?.exerciseDescriptionLbl?.isHidden = false
    })
  }
  
  private func playCountdownCombined() {
    self.exerciseViewController.startVideoCapture()
    _ = self.countDownSound?.play()
    _ = try? self.countDown?.play(completion: { [weak self] in
      self?.exerciseDescriptionLbl?.isHidden = true
      self?.exerciseDescriptionLbl?.removeFromSuperview()
      self?.exerciseDescriptionLbl = nil
      self?.gameHeading?.lottieAnimationView.removeFromSuperview()
      self?.gameHeading = nil
      _ = try? self?.minFrame(minFrame: 80).maxFrame(maxFrame: 98).play(completion: {
        self?.renderView.scoreView.isHidden = false
//        self?.renderView.progressionBar.isHidden = false
        self?.exerciseViewController.exercise?.startMainExercise()
        self?.exerciseViewController.canShowHiddenButton = true
        self?.clearDidStart()
      })
    })
  }
  
}
