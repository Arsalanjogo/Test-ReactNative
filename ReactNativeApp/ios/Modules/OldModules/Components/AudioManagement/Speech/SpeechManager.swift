//
//  SpeechManager.swift
//  jogo
//
//  Created by arham on 21/05/2021.
//

import Foundation
import AVFoundation

class SpeechManager {
  // ONLY for Debugging.
  // Use this to provide audio prompts.
  
  
  static var shared: SpeechManager? = SpeechManager()
  var synthesizer: AVSpeechSynthesizer
  var previousSentenceUtterance: Double
  var gapBetweenPrompts: Double = 0
  
  public static func get() -> SpeechManager {
    if SpeechManager.shared == nil {
      SpeechManager.shared = SpeechManager()
    }
    return SpeechManager.shared!
  }
  
  public static func remove() {
    if SpeechManager.shared != nil {
      SpeechManager.shared = nil
    }
  }
  
  init() {
    previousSentenceUtterance = Date().getMilliseconds()
    synthesizer = AVSpeechSynthesizer()
  }
  
  public func talk(sentence: String) {
//    guard ExerciseSettings.DEBUG_MODE else { return }
    if synthesizer.isSpeaking { return }
    let curTime: Double = Date().getMilliseconds()
    if curTime - previousSentenceUtterance < gapBetweenPrompts { return }
    let utterance = AVSpeechUtterance(string: sentence)
    utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
//    utterance.rate = 0.60
    synthesizer.speak(utterance)
    utterance.postUtteranceDelay = gapBetweenPrompts
    previousSentenceUtterance = curTime
  }
  
  public func stopSpeakingImmediately() {
    synthesizer.stopSpeaking(at: .immediate)
  }
  
  
}
