//
//  Number.swift
//  Football433
//
//  Created by arham on 14/12/2021.
//

import Foundation

class Number: Codable, FlblPrimitiveType {
  var number: Double?
  
  init(_ number: Double?) {
    self.number = number
  }
  
  init(_ bool: Bool?) {
    if bool == nil { return }
    self.number = bool! ? 1 : 0
  }
  
  init(_ integer: Int?) {
    if integer == nil { return }
    self.number = Double(integer ?? 0)
  }
  
  func getDouble() -> Double? {
    return self.number
  }
  
  func getBoolean() -> Bool? {
    guard let number = number else {
      return nil
    }
    return number > 0.0 ? true : false
  }
  
  func getInt() -> Int? {
    guard let number = number else {
      return nil
    }
    return Int(number)
  }
}
