//
//  AtomicCounter.swift
//  jogo
//
//  Created by Sulman on 04/03/2021.
//

import Foundation

class Counter {
  private let queue = DispatchQueue(label: "...")
  private var value: Int = 0
  func counterValue() -> Int { queue.sync { value } }
  func increment(_ n: Int = 1) { queue.sync { value += n } }
  func reset() { queue.sync { value = 0 } }

}
