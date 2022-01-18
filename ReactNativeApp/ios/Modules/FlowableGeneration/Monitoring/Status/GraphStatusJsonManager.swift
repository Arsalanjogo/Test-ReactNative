//
//  GraphStatusJsonManager.swift
//  Football433
//
//  Created by arham on 27/12/2021.
//

import Foundation


class GraphStatusJsonManager {
  
  private static var shared: GraphStatusJsonManager?
  
  private var flowableStatusJsonPath: URL?
  private var graphJsonCodable: [String: [FrameStatusCodable]]?
  
  private init() { }
  
  public static func get() -> GraphStatusJsonManager {
    if GraphStatusJsonManager.shared == nil {
      GraphStatusJsonManager.shared = GraphStatusJsonManager()
    }
    return GraphStatusJsonManager.shared!
  }
  
  public static func remove() {
    if GraphStatusJsonManager.shared != nil {
      GraphStatusJsonManager.shared = nil
    }
  }
  
  public func getFlowableStatusJSON() -> [String: [FrameStatusCodable]] {
    if graphJsonCodable == nil {
      graphJsonCodable = [String: [FrameStatusCodable]]()
      
    }
    return graphJsonCodable!
  }
  
  public func resetGraphJSON() {
    self.flowableStatusJsonPath = nil
    _ = self.getExerciseJsonPath()
  }
  
  public func getExerciseJsonPath() -> URL {
    if flowableStatusJsonPath == nil {
      let jsonName: String = "\(GameContext.getContext()?.getGame()?.rawValue ?? "NoName")_GraphStatus_\(Date().getMilliseconds()).json"
      flowableStatusJsonPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(jsonName)
    }
    return flowableStatusJsonPath!
  }
  
  public func setExerciseJSON(value: [String: [FrameStatusCodable]]) {
    self.graphJsonCodable = value
  }
  
  public func saveStatusForFlowable(frameId: String, flowable_id: String, value: FlowableStatusCodable) {
    guard let graphJsonCodable = graphJsonCodable else {
      return
    }
    let keyExists = graphJsonCodable[frameId] != nil
    if keyExists {
      self.graphJsonCodable![frameId]!.append(FrameStatusCodable(name: flowable_id, status: value))
    } else {
      self.graphJsonCodable![frameId] = []
      self.graphJsonCodable![frameId]!.append(FrameStatusCodable(name: flowable_id, status: value))
    }
  }
  
  func convertAndWriteToFile() {
    let encoder: JSONEncoder = JSONEncoder()
    if ExerciseSettings.DEBUG_MODE {
      encoder.outputFormatting = .prettyPrinted
    }
    
    do {
      try encoder.encode(graphJsonCodable!).write(to: flowableStatusJsonPath!)
    } catch {
      Logger.shared.logError(logType: .ERROR, error: error, extraMsg: "Unable to write JSON file!")
    }
  }
  
  
}
