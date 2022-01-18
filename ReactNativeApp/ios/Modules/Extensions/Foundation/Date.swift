//
//  Date.swift
//  jogo
//
//  Created by arham on 01/07/2021.
//

import Foundation

extension Date {
  func getMilliseconds() -> Double {
    return self.timeIntervalSince1970*1000
  }
  
  func getNanoseconds() -> Double {
    return self.timeIntervalSince1970*1_000_000
  }
}
