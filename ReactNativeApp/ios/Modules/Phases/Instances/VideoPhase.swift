//
//  VideoPhase.swift
//  jogo
//
//  Created by Muhammad Nauman on 26/10/2021.
//

import Foundation

public class VideoPhase: Phase {
  
  var video: SSVC<VideoState, VideoView, VideoController>!
  
  public override func process() {
    
  }
  
  public override func isDone() -> Bool {
    return video.controller.isDone()
  }
  
  public override func initialize() {
    super.initialize()
    self.phaseName = "Video"
    self.nextPhase = .PromoPhase
    self.prevPhase = .ContextInitPhase
    video = VideoBuilder.build()
    Profiler.get().profileTime(frameId: GameContext.getContext()?.currentFrameNumber ?? -1, tag: "\(self.phaseName ?? "" )-\(#function)", delta: Date().getMilliseconds() - timings["\(#function)"]!)
  }
  
  public override func cleanup() {
    super.cleanup()
    self.video.cleanup()
    self.video = nil
    Profiler.get().profileTime(frameId: GameContext.getContext()?.currentFrameNumber ?? -1, tag: "\(self.phaseName ?? "" )-\(#function)", delta: Date().getMilliseconds() - timings["\(#function)"]!)
    
  }
  
}
