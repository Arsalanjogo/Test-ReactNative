//
//  Double.swift
//  jogo
//
//  Created by arham on 02/08/2021.
//

import Foundation

extension Double {
  
  func n_dp(dp: Double) -> Double {
    let multiplier: Double = pow(10, dp)
    return (self * multiplier).rounded()/multiplier
  }
  
  func n_dp_str() -> String {
    return String(format: "%.3f", self)
  }
}
