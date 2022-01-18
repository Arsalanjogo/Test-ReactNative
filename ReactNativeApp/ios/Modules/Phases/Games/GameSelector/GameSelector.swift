//
//  GameSelector.swift
//  jogo
//
//  Created by arham on 19/11/2021.
//

import Foundation

public enum GamePhasesName: String {
  case Juggling = "Juggling"
  case GraphGame = "GraphGame"
  case JugglingGraph = "JugglingGraph"
}

class GameSelector {
  
  static func select(name: GamePhasesName) -> GamePhase.Type? {
    switch name {
    case .Juggling:
      return JugglingPhase.self
    case .GraphGame:
      return GraphGamePhase.self
    case .JugglingGraph:
      return GraphGamePhase.self
    }
  }
}
