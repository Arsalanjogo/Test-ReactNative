//
//  PredicateFactory.swift
//  jogo
//
//  Created by arham on 04/08/2021.
//

import Foundation


class PredicateFactory {
  
  public static func build(val: resState) throws -> PredicateCalculatorProtocol {
    let type: String = val.type
    switch type {
    case "angle":
      return try Angle(val: val)
    default:
      throw PredicateFactoryError("No such type exist for resolution state: \(type)")
    }
    
  }
}


struct PredicateFactoryError: Error {
    let message: String

    init(_ message: String) {
        self.message = message
    }

    public var localizedDescription: String {
        return message
    }
}
