//
//  ThermalProfiler.swift
//  jogo
//
//  Created by arham on 09/09/2021.
//

import Foundation

class ThermalProfiler: ProfilerProtocol {
  
  private init() { }
  
  private static let thermalStateConverter: [Int: String] = [
    0: "nominal",
    1: "fair",
    2: "serious",
    3: "critical"]
  
  static func getThermalState() -> ProcessInfo.ThermalState {
    return ProcessInfo.processInfo.thermalState
  }
  
  static func getThermalStateRaw() -> Int {
    return ProcessInfo.processInfo.thermalState.rawValue
  }
  
  static func get() -> String {
    self.thermalStateConverter[ProcessInfo.processInfo.thermalState.rawValue] ?? "Errored"
  }
}
