//
//  VideoState.swift
//  jogo
//
//  Created by Muhammad Nauman on 26/10/2021.
//

import Foundation
import AVFoundation

public class VideoState: State {
  
  var videoURLString = "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
  var avPlayer: AVPlayer?
  var isVideoEnded = false
  //TODO: Need to discuss this openly for communication in SSVC
  var skipButton: UIButton?
  
}
