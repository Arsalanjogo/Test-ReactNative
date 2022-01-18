//
//  VideoView.swift
//  jogo
//
//  Created by Muhammad Nauman on 26/10/2021.
//

import Foundation
import AVFoundation

public class VideoView: LayoutSV {
  
  init(state: VideoState) {
    super.init(state: state, frame: RenderLoop.getFrame()!)
    
    if let url = URL(string: state.videoURLString) {
      state.avPlayer = AVPlayer(url: url)
      let playerLayer = AVPlayerLayer(player: state.avPlayer)
      playerLayer.frame = self.frame
      self.backgroundColor = .black
      self.layer.addSublayer(playerLayer)
      addSkipButton()
    }
    RenderLoop.addStaticLayoutStateView(layoutSV: self)
  }
  
  func addSkipButton() {
    guard let videoState = state as? VideoState else { return }
    videoState.skipButton = UIButton(frame: .zero)
    self.addSubview(videoState.skipButton!)
    videoState.skipButton?.translatesAutoresizingMaskIntoConstraints = false
    videoState.skipButton?.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -24).isActive = true
    videoState.skipButton?.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24).isActive = true
    videoState.skipButton?.widthAnchor.constraint(equalToConstant: 100).isActive = true
    videoState.skipButton?.heightAnchor.constraint(equalToConstant: 50).isActive = true
    videoState.skipButton?.setTitle("SKIP", for: .normal)
    videoState.skipButton?.backgroundColor = .yellow
    videoState.skipButton?.setTitleColor(.black, for: .normal)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override func draw(canvas: UIView) {
    super.draw(canvas: canvas)
  }
  
  public override func removeFromSuperview() {
    super.removeFromSuperview()
    (state as! VideoState).avPlayer = nil
    self.layer.sublayers?.removeAll()
  }
  
}
