//
//  SoundBase.swift
//  jogo
//
//  Created by Nauman on 24/05/2021.
//

import AVFoundation

class SoundRender: NSObject, AVAudioPlayerDelegate{
  
  typealias NoArgMethod = () -> Void
  private static var activePlayer = Set<AVAudioPlayer>()
  private var onEnd: [NoArgMethod] = []
  private var audioPlayer: AVAudioPlayer?
  private var running = false
  
  init(value: SoundMapping.SoundDef) {
    super.init()
    do {
      audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: value.filename, ofType: value.ext)!))
      audioPlayer?.prepareToPlay()
      audioPlayer?.delegate = self
      SoundManager.get().insert(sound: self, soundName: value)
    } catch {
      print(error.localizedDescription)
    }
  }
  
  func play() -> SoundRender {
    if let player = self.audioPlayer {
      player.currentTime = 0
      player.play()
    }
    return self
  }
  
  func speed(value: Float) -> SoundRender {
    if self.audioPlayer != nil {
      self.audioPlayer?.rate = value
      self.audioPlayer?.enableRate = true
    }
    return self
  }
  
  func stop() -> SoundRender {
    if let player = self.audioPlayer {
      player.stop()
    }
    return self
  }
  
  func onEnd(method: @escaping NoArgMethod) -> SoundRender {
    self.onEnd.append(method)
    return self
  }
  
  // MARK: AVAudioPlayerDelegate
  func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    if flag {
      self.onEnd.forEach { (method) in
        method()
      }
    }
  }
  
}
