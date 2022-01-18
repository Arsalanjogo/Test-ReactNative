//
//  ExerciseCodable.swift
//  jogo
//
//  Created by arham on 04/08/2021.
//

import Foundation

// MARK: 1st Order of JSON
// ***********************

struct ExerciseCodable: Codable {
  var state: [StateCodable]
}

// MARK: 2nd Order of JSON
// ***********************

struct StateCodable: Codable {
  var onStart: [onState]
  var onProcess: [onState]
  var onEnd: [onState]
  var resolution: [resState]
  var nextStateKey: String
  var key: String
  
  enum CodingKeys: String, CodingKey {
    case onStart = "on-start"
    case onProcess = "on-process"
    case onEnd = "on-end"
    case resolution = "resolution"
    case nextStateKey = "next-state-key"
    case key = "key"
  }
}


// MARK: 3rd Order of JSON
// ***********************


// MARK: State dict
struct onState: Codable {
  var type: String?
  var asset: String?
  var amount: Int?
  var blink: Bool?
  var bleep: Bool?
}

// MARK: Resolution dict
struct resState: Codable {
  var type: String
  var i1: StateElement
  var i2: StateElement
  var i3: StateElement
  var minAngle: Int
  var maxAngle: Int
  
  enum CodingKeys: String, CodingKey {
    case type = "type"
    case i1 = "i1"
    case i2 = "i2"
    case i3 = "i3"
    case minAngle = "min-angle"
    case maxAngle = "max-angle"
  }
}


// MARK: 4th Order of JSON
// ***********************

struct StateElement: Codable {
  var type: String
  var key: String
}
