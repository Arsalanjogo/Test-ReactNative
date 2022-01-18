//
//  LottieMotionPrompt.swift
//  jogo
//
//  Created by arham on 08/07/2021.
//
import Foundation

class LottieMotionPrompt {
  
  enum STATE {
    case UP
    case DOWN
    case JUMP
    case KNEEL
  }
  
  internal var up: LottieRender?
  internal var down: LottieRender?
  internal var kneel: LottieRender?
  internal var jump: LottieRender?
  
  init(exerciseVC: ExerciseViewController, upAsset: Bool = true, downAsset: Bool = true, kneelAsset: Bool = true, jumpAsset: Bool = true) {
    if upAsset {
      up = try? LottieRender(exerciseVC: exerciseVC, animationName: LottieMapping.Prompts.up.rawValue).onStop { [weak self] in
        self?.up?.lottieAnimationView.isHidden = true
      }.onStart { [weak self] in
        self?.up?.lottieAnimationView.isHidden = false
      }.scale(x: 0.25, y: 0.5).move(x: 0.5, y: 0.5)
      self.up?.lottieAnimationView.isHidden = true
    }
    
    if downAsset {
      down = try? LottieRender(exerciseVC: exerciseVC, animationName: LottieMapping.Prompts.down.rawValue).onStop { [weak self] in
        self?.down?.lottieAnimationView.isHidden = true
      }.onStart { [weak self] in
        self?.down?.lottieAnimationView.isHidden = false
      }.scale(x: 0.5, y: 0.5).move(x: 0.5, y: 0.5)
      self.down?.lottieAnimationView.isHidden = true
    }
    
    if kneelAsset {
      kneel = try? LottieRender(exerciseVC: exerciseVC, animationName: LottieMapping.Prompts.kneel.rawValue).onStop { [weak self] in
        self?.kneel?.lottieAnimationView.isHidden = true
      }.onStart { [weak self] in
        self?.kneel?.lottieAnimationView.isHidden = false
      }.scale(x: 0.5, y: 0.5).move(x: 0.5, y: 0.5)
      self.kneel?.lottieAnimationView.isHidden = true
    }
    
    if jumpAsset {
      jump = try? LottieRender(exerciseVC: exerciseVC, animationName: LottieMapping.Prompts.jump.rawValue).onStop { [weak self] in
        self?.jump?.lottieAnimationView.isHidden = true
      }.onStart { [weak self] in
        self?.jump?.lottieAnimationView.isHidden = false
      }.scale(x: 0.5, y: 0.5).move(x: 0.5, y: 0.5)
      self.jump?.lottieAnimationView.isHidden = true
    }
  }
  
  func play(state: STATE) {
    switch state {
    case .UP:
      _ = try? self.up?.play()
    case .DOWN:
      _ = try? self.down?.play()
    case .JUMP:
      _ = try? self.jump?.play()
    case .KNEEL:
      _ = try? self.kneel?.play()
    }
  }
}
