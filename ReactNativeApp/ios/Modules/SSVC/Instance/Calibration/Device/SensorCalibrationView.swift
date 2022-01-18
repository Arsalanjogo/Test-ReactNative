//
//  SensorCalibrationView.swift
//  jogo
//
//  Created by Mohsin on 20/10/2021.
//

import Foundation
import Lottie
import RxCocoa
import RxSwift
import UIKit

public class SensorCalibrationView: LayoutSV {
  
  // MARK: Setup
  private let disposeBag = DisposeBag()
  
  // MARK: Constants
  private let ANIMATION_PROMPT_HEIGHT_WIDTH: CGFloat = 200 // 1:1
  private let LEVEL_ANIMATION_SIZE: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 400 : 300
  
  // MARK: Controls
  private var rotationLabel: UILabel!
  private var leftAnimationView: AnimationView!
  private var rightAnimationView: AnimationView!
  private var upAnimationView: AnimationView!
  private var downAnimationView: AnimationView!
  
  private var rotationAnimationView: AnimationView!
  private var tiltAnimationView: AnimationView!
  
  init(state: SensorCalibrationState) {
    super.init(state: state, frame: RenderLoop.getFrame()!)
    setupViews()
    bindState()
    RenderLoop.addStaticLayoutStateView(layoutSV: self)
  }
  
  // MARK: Bind to State
  fileprivate func bindState() {
    guard let state = self.state as? SensorCalibrationState else { return }
    
    // Rotation Text Changes
    state.rotationText
      .asObservable()
      .bind(to: rotationLabel.rx.text)
      .disposed(by: disposeBag)
    
    // Rotation Prompt Changes
    state.rotationPrompt
      .asObservable()
      .subscribe(onNext: { [weak self] prompts in
        guard let strongSelf = self else { return }
        
        // Vertical
        switch prompts.0 {
        case .UP:
          strongSelf.downAnimationView.isHidden = true
          strongSelf.upAnimationView.isHidden = false
        case .DOWN:
          strongSelf.upAnimationView.isHidden = true
          strongSelf.downAnimationView.isHidden = false
        default:
          strongSelf.downAnimationView.isHidden = true
          strongSelf.upAnimationView.isHidden = true
        }

        // Horizontal
        switch prompts.1 {
        case .LEFT:
          strongSelf.rightAnimationView.isHidden = true
          strongSelf.leftAnimationView.isHidden = false
        case .RIGHT:
          strongSelf.leftAnimationView.isHidden = true
          strongSelf.rightAnimationView.isHidden = false
        default:
          strongSelf.leftAnimationView.isHidden = true
          strongSelf.rightAnimationView.isHidden = true
        }
      })
      .disposed(by: disposeBag)
    
    
    // Rotation Level Frame Changes
    state.rotationAnimFrames
      .subscribe(onNext: { [weak self] frames in
        guard let strongSelf = self else { return }
        // Vertical Rotation
        strongSelf.tiltAnimationView.play(
          fromFrame: frames.0,
          toFrame: frames.0,
          loopMode: .none,
          completion: nil
        )
        // Horizontal Rotation
        strongSelf.rotationAnimationView.play(
          fromFrame: frames.1,
          toFrame: frames.1,
          loopMode: .none,
          completion: nil
        )
      })
      .disposed(by: disposeBag)
    
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
}

// MARK: Setup Views
extension SensorCalibrationView {
  fileprivate func setupViews() {
    addRotationLabel()
    addAnimations()
  }
  
  func addAnimations() {
    guard let state = self.state as? SensorCalibrationState else { return }
    
    // LEFT
    leftAnimationView = AnimationView(animation: Animation.named(LottieMapping.RotationPrompt.LEFT.rawValue))
    leftAnimationView.isHidden = true
    leftAnimationView.loopMode = .autoReverse
    leftAnimationView.play(completion: nil)
    self.addSubview(leftAnimationView)
    leftAnimationView.translatesAutoresizingMaskIntoConstraints = false
    leftAnimationView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
    leftAnimationView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    leftAnimationView.heightAnchor.constraint(equalToConstant: ANIMATION_PROMPT_HEIGHT_WIDTH).isActive = true
    leftAnimationView.widthAnchor.constraint(equalToConstant: ANIMATION_PROMPT_HEIGHT_WIDTH).isActive = true
    
    // RIGHT
    rightAnimationView = AnimationView(animation: Animation.named(LottieMapping.RotationPrompt.RIGHT.rawValue))
    rightAnimationView.isHidden = true
    rightAnimationView.loopMode = .autoReverse
    rightAnimationView.play(completion: nil)
    self.addSubview(rightAnimationView)
    rightAnimationView.translatesAutoresizingMaskIntoConstraints = false
    rightAnimationView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
    rightAnimationView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    rightAnimationView.heightAnchor.constraint(equalToConstant: ANIMATION_PROMPT_HEIGHT_WIDTH).isActive = true
    rightAnimationView.widthAnchor.constraint(equalToConstant: ANIMATION_PROMPT_HEIGHT_WIDTH).isActive = true
    
    // UP
    upAnimationView = AnimationView(animation: Animation.named(LottieMapping.RotationPrompt.UP.rawValue))
    upAnimationView.isHidden = true
    upAnimationView.loopMode = .autoReverse
    upAnimationView.play(completion: nil)
    self.addSubview(upAnimationView)
    upAnimationView.translatesAutoresizingMaskIntoConstraints = false
    upAnimationView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
    upAnimationView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    upAnimationView.heightAnchor.constraint(equalToConstant: ANIMATION_PROMPT_HEIGHT_WIDTH).isActive = true
    upAnimationView.widthAnchor.constraint(equalToConstant: ANIMATION_PROMPT_HEIGHT_WIDTH).isActive = true
    
    // DOWN
    downAnimationView = AnimationView(animation: Animation.named(LottieMapping.RotationPrompt.DOWN.rawValue))
    downAnimationView.isHidden = true
    downAnimationView.loopMode = .autoReverse
    downAnimationView.play(completion: nil)
    self.addSubview(downAnimationView)
    downAnimationView.translatesAutoresizingMaskIntoConstraints = false
    downAnimationView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -40).isActive = true
    downAnimationView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    downAnimationView.heightAnchor.constraint(equalToConstant: ANIMATION_PROMPT_HEIGHT_WIDTH).isActive = true
    downAnimationView.widthAnchor.constraint(equalToConstant: ANIMATION_PROMPT_HEIGHT_WIDTH).isActive = true
    
    // ROTATION
    rotationAnimationView = AnimationView(animation: Animation.named(LottieMapping.RotationPrompt.ROTATION.rawValue))
//    rotationAnimationView.isHidden = true
    rotationAnimationView.loopMode = .autoReverse
    rotationAnimationView.play(fromFrame: 0.0, toFrame: state.MAX_ANIMATION_FRAME / 2, loopMode: .playOnce, completion: nil)
    self.addSubview(rotationAnimationView)
    rotationAnimationView.translatesAutoresizingMaskIntoConstraints = false
    rotationAnimationView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -40).isActive = true
    rotationAnimationView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    rotationAnimationView.widthAnchor.constraint(equalToConstant: LEVEL_ANIMATION_SIZE).isActive = true
    
    
    // TILT
    tiltAnimationView = AnimationView(animation: Animation.named(LottieMapping.RotationPrompt.TILT.rawValue))
//    tiltAnimationView.isHidden = true
    tiltAnimationView.loopMode = .autoReverse
    tiltAnimationView.play(fromFrame: 0.0, toFrame: state.MAX_ANIMATION_FRAME / 2, loopMode: .playOnce, completion: nil)
    self.addSubview(tiltAnimationView)
    tiltAnimationView.translatesAutoresizingMaskIntoConstraints = false
    tiltAnimationView.leadingAnchor.constraint(equalTo: rotationAnimationView.trailingAnchor, constant: 0).isActive = true
    tiltAnimationView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    tiltAnimationView.heightAnchor.constraint(equalToConstant: LEVEL_ANIMATION_SIZE).isActive = true
  }
  
  func addRotationLabel() {
    rotationLabel = UILabel()
    rotationLabel.textAlignment = .center
    rotationLabel.textColor = .white
    self.addSubview(rotationLabel)
    rotationLabel.translatesAutoresizingMaskIntoConstraints = false
    rotationLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    rotationLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    rotationLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
    rotationLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
  }
  
}
