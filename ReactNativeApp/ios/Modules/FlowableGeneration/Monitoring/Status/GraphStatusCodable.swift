//
//  GraphStatusCodable.swift
//  Football433
//
//  Created by arham on 27/12/2021.
//

import Foundation

struct PortValuesCodable: Codable {
  var name: String
  var value: String
}

struct FlowableStatusCodable: Codable {
  var status: String
  var inputPorts: [PortValuesCodable]?
  var outputPorts: [PortValuesCodable]?
}

struct FrameStatusCodable: Codable {
  var name: String
  var status: FlowableStatusCodable
}
