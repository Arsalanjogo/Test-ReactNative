//
//  GraphGamePhase.swift
//  jogo
//
//  Created by arham on 29/11/2021.
//

import Foundation

public class GraphGamePhase: GamePhase {
  
  private var graph: FlowableGraphManager?
  
  required init(delegate: GamePhaseDelegate, stopRestart: Bool) {
    super.init(delegate: delegate, stopRestart: stopRestart)
  }
  
  /// Provides the functionality of returning the completion of this phase as well as writing down
  /// the value of the complete elapsed time of the game phase.
  public override func isDone() -> Bool {
    let isDone: Bool = timer?.controller.timeFinished() ?? true
    if isDone {
      ExerciseStatsJsonManager.get().fillProperties(completionTime: timer?.controller.getCompletionTime() ?? 0.0)
      ExerciseStatsJsonManager.get().convertAndWriteToFile()
      
      _ = GraphStatusJsonManager.get().getExerciseJsonPath()
      GraphStatusJsonManager.get().convertAndWriteToFile()
    }
    return isDone
  }
  
  public override func initialize() {
    self.phaseName = "GraphGame"
    graph = FlowableGraphManager(fileName: GameContext.getContext()?.fileName ?? "")
    _ = GraphStatusJsonManager.get().getFlowableStatusJSON()
    super.initialize()

    Profiler.get().profileTime(frameId: GameContext.getContext()?.currentFrameNumber ?? -1, tag: "\(self.phaseName ?? "" )-\(#function)", delta: Date().getMilliseconds() - timings["\(#function)"]!)
  }
  
  public override func process() {
    super.process()
    do {
      guard let context = GameContext.getContext() else { return }
      let _infoBlob: InfoBlob? = try context.infoBlobArrayList.getLast()
      guard let infoBlob = _infoBlob else { return }
      graph?.process()
    } catch {
      Logger.shared.logError(text: "Context InfoBlob last value was not retreivable.")
    }
    Profiler.get().profileTime(frameId: GameContext.getContext()?.currentFrameNumber ?? -1, tag: "\(self.phaseName ?? "" )-\(#function)", delta: Date().getMilliseconds() - timings["\(#function)"]!)
  }
  
  public override func cleanup() {
    self.graph?.cleanup()
    self.graph = nil
    super.cleanup()
  }
  
  public override func getDebugText() -> String {
    return ""
  }
}
