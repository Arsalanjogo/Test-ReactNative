//
//  JugglingPhase.swift
//  jogo
//
//  Created by arham on 19/11/2021.
//

import Foundation

public class JugglingPhase: GamePhase {
  
  var game: SSVC<JugglingState, JugglingView, JugglingController>?
  
  required init(delegate: GamePhaseDelegate, stopRestart: Bool) {
    super.init(delegate: delegate, stopRestart: stopRestart)
  }
  
  public override func initialize() {
    self.phaseName = "Juggling"
    game = JugglingBuilder.build(ballController: ball?.controller,
                                 personController: person?.controller,
                                 pointController: points?.controller)
    super.initialize()
    Profiler.get().profileTime(frameId: GameContext.getContext()?.currentFrameNumber ?? -1, tag: "\(self.phaseName ?? "" )-\(#function)", delta: Date().getMilliseconds() - timings["\(#function)"]!)
  }
  
  public override func process() {
    super.process()
    do {
      guard let context = GameContext.getContext() else { return }
      let _infoBlob: InfoBlob? = try context.infoBlobArrayList.getLast()
      guard let infoBlob = _infoBlob else { return }
      game?.controller.process(infoBlob: infoBlob)
    } catch {
      Logger.shared.logError(text: "Context InfoBlob last value was not retreivable.")
    }
    Profiler.get().profileTime(frameId: GameContext.getContext()?.currentFrameNumber ?? -1, tag: "\(self.phaseName ?? "" )-\(#function)", delta: Date().getMilliseconds() - timings["\(#function)"]!)
  }
  
  public override func cleanup() {
    self.game?.cleanup()
    self.game = nil
    super.cleanup()
  }
  
  public override func getDebugText() -> String {
    return ""
  }
}
