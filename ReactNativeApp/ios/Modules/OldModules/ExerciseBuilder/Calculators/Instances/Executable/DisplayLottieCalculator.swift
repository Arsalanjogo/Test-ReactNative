//
//  DisplayLottieCalculator.swift
//  jogo
//
//  Created by arham on 04/08/2021.
//

import Foundation


class DisplayLottieCalculator: ExecutableCalculatorProtocol {

  let assetName: String
  
  init(val: onState) {
    assetName = val.asset ?? ""
  }
  
  func execute() throws {
    switch (assetName) {
    case "jump.json":
      BaseExercise.baseExercise?.getExerciseRenderModule().showPrompt(promptType: .JUMP)
    default:
      throw DisplayLottieError("\(assetName) is invalid.")
    }
  }
  
  func debugString() -> String {
    return assetName
    
  }
}

struct DisplayLottieError: Error {
    let message: String

    init(_ message: String) {
        self.message = message
    }

    public var localizedDescription: String {
        return message
    }
}
