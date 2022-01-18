//
//  ExerciseDefinitionCodable.swift
//  jogo
//
//  Created by arham on 20/10/2021.
//

import Foundation

struct _ExerciseDefiniton: Codable {
  var metadata: _MetaData
  var pipes: [_Pipe]
  var flowables: [_Flowable]
}

/*
 ObjectsNeeded:
 type: String -> hashmap[String] -> Enum(person, ball) -> ObjectDetection
 variation: String -> hashmap[String] -> Enum(fast, normal, heavy) -> String(model-name)
 */

struct _ObjectsNeeded: Codable {
  var type: String
  var variation: String
}

/*
 Calibration:
 type: String -> switch -> CalibrationInstance.
 animation: String -> switch -> AnimationPackage.
 */
struct _Calibration: Codable {
  var type: String
  var animation: String
}

struct _MetaData: Codable {
  var gameName: String
  var objectsNeeded: [_ObjectsNeeded]
  var exerciseDuration: Int
  var calibration: _Calibration?
}

struct _Pipe: Codable {
  var from: String
  var to: String
}

///Flowable defintion has the options as the following parametrization:
/// name: Name of the Flowable
/// type: The overarching type of the Flowable
/// subtype: The specific type of the flowable so identification of the unique flowable logic can be achieved
/// uid: The unique id given to the specific flowable
/// id: The id of the flowable
/// options: The options provided by the desinger to be incorporated in the
struct _Flowable: Codable {
  var name: String
  var type: String
  var subtype: String
  var uid: String
  var id: String
  var options: [String: Any]?
  
  private enum StaticCodingKeys: String, CodingKey {
    case name, type, subtype, uid, id, options
  }
  
  private struct DynamicCodingKeys: CodingKey {
    var stringValue: String
    
    init?(stringValue: String) {
      self.stringValue = stringValue
    }
    
    var intValue: Int?
    
    init?(intValue: Int) {
      self.init(stringValue: "")
      self.intValue = intValue
    }
    
    var doubleValue: Double?
    
    init?(doubleValue: Double) {
      self.init(stringValue: "")
      self.doubleValue = doubleValue
    }
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: StaticCodingKeys.self)
    self.name = try container.decode(String.self, forKey: .name)
    self.type = try container.decode(String.self, forKey: .type)
    self.subtype = try container.decode(String.self, forKey: .subtype)
    self.uid = try container.decode(String.self, forKey: .uid)
    self.id = try container.decode(String.self, forKey: .id)
    do {
      self.options = try _Flowable.decodeOptions(from: container.superDecoder(forKey: .options))
    } catch {}
    
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: StaticCodingKeys.self)
    try container.encode(self.name, forKey: .name)
    try container.encode(self.type, forKey: .type)
    try container.encode(self.subtype, forKey: .subtype)
    try container.encode(self.subtype, forKey: .subtype)
    try container.encode(self.uid, forKey: .uid)
    try container.encode(self.id, forKey: .id)
    do {
      try encodeOptions(to: container.superEncoder(forKey: .options))
    } catch {}
    
  }
  
  static func decodeOptions(from decoder: Decoder) throws -> [String: Any]? {
    let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
    var result: [String: Any] = [:]
    for key in container.allKeys {
      if let double = try? container.decode(Double.self, forKey: key) {
        result[key.stringValue] = double
      } else if let string = try? container.decode(String.self, forKey: key) {
        result[key.stringValue] = string
      } else if let integer = try? container.decode(Int.self, forKey: key) {
        result[key.stringValue] = integer
      }
    }
    return result
  }
  
  func encodeOptions(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: DynamicCodingKeys.self)
    guard let options = options else { return }
    for (key, value) in options {
      switch value {
      case let double as Double:
        try container.encode(double, forKey: DynamicCodingKeys(stringValue: key)!)
      case let string as String:
        try container.encode(string, forKey: DynamicCodingKeys(stringValue: key)!)
      case let integer as Int:
        try container.encode(integer, forKey: DynamicCodingKeys(stringValue: key)!)
      default:
        fatalError("unexpected type")
      }
    }
  }
}
