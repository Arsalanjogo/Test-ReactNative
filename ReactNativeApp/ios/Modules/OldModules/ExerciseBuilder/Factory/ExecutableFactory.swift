//
//  ExecutableFactory.swift
//  jogo
//
//  Created by arham on 04/08/2021.
//

import Foundation


public class ExecutableFactory {
  
  static func build(val: onState) throws -> ExecutableCalculatorProtocol {
    switch(val.type) {
    case "lottie":
      return DisplayLottieCalculator(val: val)
    case "increment-score":
      return try IncrementScoreCalculator(val: val)
    default:
      throw ExecutableFactoryError("Value of the type key is outside of the valid range of values.")
    }
  }
  
}

struct ExecutableFactoryError: Error {
    let message: String

    init(_ message: String) {
        self.message = message
    }

    public var localizedDescription: String {
        return message
    }
}
