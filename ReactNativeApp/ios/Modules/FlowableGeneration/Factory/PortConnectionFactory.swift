//
//  PipeFactory.swift
//  jogo
//
//  Created by arham on 21/10/2021.
//

import Foundation


class PortConnectionFactory {
  
  init() { }
  
  static func build(portConnections: [_Pipe]) -> [PortConnections] {
    var pps: [PortConnections] = []
    portConnections.forEach { p in
      pps.append(PortConnections(val: p))
    }
    
    return pps
  }
}
