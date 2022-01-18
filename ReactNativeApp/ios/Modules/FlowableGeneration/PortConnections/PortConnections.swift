//
//  PortConnections.swift
//  jogo
//
//  Created by arham on 21/10/2021.
//

import Foundation


struct PortConnectionDefinition: Hashable {
  var flowable_type: String
  var flowable_id: String
  var port_io: String
  var port_id: String
  var port_sequence: Int
}

class PortConnections {
  
  private let main_sep: Character = "$"
  private let sec_sep: Character = ":"
  private let port_def_sep: Character = "_"
  
  let port_connection_id: String
  let value: _Pipe
  
  var input_port_definition: PortConnectionDefinition!
  var output_port_definition: PortConnectionDefinition!
  
  init(val: _Pipe) {
    self.port_connection_id = "\(val.from)|\(val.to)"
    self.value = val
    self.createPortDefinitions()
  }
  
  private func createPortDefinitions() {
    self.input_port_definition = self.createDefinition(value: self.value.from)
    self.output_port_definition = self.createDefinition(value: self.value.to)
  }
  
  private func createDefinition(value: String) -> PortConnectionDefinition {
    let _idef = value.split(separator: main_sep)
    let flbl_def = _idef.first!.split(separator: sec_sep)
    let port_def = _idef.last!.split(separator: sec_sep)
    let port_sequence_: String = String(String(port_def.last!).split(separator: port_def_sep).last!)
    let result: String = port_sequence_.filter("0123456789.".contains)
    let port_sequence: Int = Int(result)!
    
    // Force unwrapping here so that if any of these definitions are not in the string. Crash as the json is wrong.
    return PortConnectionDefinition(
      flowable_type: String(flbl_def.first!),
      flowable_id: String(flbl_def.last!),
      port_io: String(port_def.first!),
      port_id: String(port_def.last!),
      port_sequence: port_sequence)
  }
}
