//
//  ProfilingCodable.swift
//  jogo
//
//  Created by arham on 08/09/2021.
//

import Foundation

typealias Tag = String

struct ProfileCodable: Codable {
  var timeProfile: [Tag: FrameProfileCodable]
  var tempProfile: BasicProfileInfoCodable
  var memProfile: BasicProfileInfoCodable
  var stateProfile: StateProfileInfoCodable?
}

struct FrameProfileCodable: Codable {
  var info: [Int: FrameProfileInfoCodable]
}

struct FrameProfileInfoCodable: Codable {
  var delta: Double
}

struct StateProfileInfoCodable: Codable {
  var info: [Int: String]
}

struct BasicProfileInfoCodable: Codable {
  var total: Double?
  var info: [Int: String]
}
