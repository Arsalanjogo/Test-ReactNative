//
//  Logic.swift
//  Football433
//
//  Created by arham on 14/12/2021.
//

import Foundation

class Logic: Codable, FlblPrimitiveType {
  var value: Bool?
  
  init(_ value: Bool?) {
    self.value = value
  }
  
  init(_ value: Double?) {
    if value == nil { return }
    self.value = value! > 0.0
  }
  
  init(_ value: Int?) {
    if value == nil { return }
    self.value = value! > 0
  }
  
  func getBoolean() -> Bool? {
    return self.value
  }
  
  func getDouble() -> Double? {
    guard let value = value else {
      return nil
    }
    return value ? 1.0 : 0.0
  }
  
  func getInt() -> Int? {
    guard let value = value else {
      return nil
    }
    return value ? 1 : 0
  }
}
