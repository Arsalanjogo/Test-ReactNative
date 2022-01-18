//
//  VideoController.swift
//  jogo
//
//  Created by Muhammad Nauman on 26/10/2021.
//

import Foundation

public class VideoController: Controller {
    
    init(state: VideoState) {
        super.init(state: state)
        
        state.skipButton?.addTarget(self, action: #selector(skipTapped(_:)), for: .touchUpInside)
        playVideo()
    }
    
    func playVideo() {
        if let videoState = state as? VideoState {
            videoState.avPlayer?.play()
            NotificationCenter.default.addObserver(self, selector: #selector(videoDidEnded), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: videoState.avPlayer?.currentItem)
        }
    }
    
    @objc func videoDidEnded() {
        if let videoState = state as? VideoState {
            videoState.isVideoEnded = true
        }
    }
    
    @objc func skipTapped(_ sender: UIButton) {
        if let videoState = state as? VideoState {
            videoState.isVideoEnded = true
        }
    }
    
    func isDone() -> Bool {
        return (self.state as? VideoState)?.isVideoEnded ?? false
    }
}
