//
//  VideoBuilder.swift
//  jogo
//
//  Created by Muhammad Nauman on 26/10/2021.
//

import Foundation

public class VideoBuilder: SSVCBuilder {
  
  private static func buildState() -> VideoState {
    return VideoState()
  }
  
  public static func build() -> SSVC<VideoState, VideoView, VideoController> {
    let state = buildState()
    let view = VideoView(state: state)
    let controller = VideoController(state: state)
    return SSVC(state: state, stateView: view, controller: controller)
  }
  
}
