//
//  IResolve.swift
//  jogo
//
//  Created by arham on 04/08/2021.
//

import Foundation


class IResolve {
  
  private var movableObjectPool: [String: MovingObject] = [String: MovingObject]()
  private var personInitialized: Bool = false
  
  private static var shared: IResolve?
  
  init() {
  }
  
  private static func getInstance() -> IResolve? {
    if (shared == nil) {
      shared = IResolve()
    }
    return shared
  }

  public func initPerson() {
    if personInitialized {return}
    let person: PersonDetection = PersonDetection.getInstance()
    let subclasses: Set<ObjectDetection> = person.getDetectionSubClasses()
    subclasses.forEach { objDet in
      movableObjectPool[objDet.label] = objDet
    }
    personInitialized = true
  }
  
  public static func resolve(val: StateElement) throws -> MovingObject? {
    _ = IResolve.getInstance()
    return try shared?._resolve(val: val) ?? nil
  }
  
  private func _resolve(val: StateElement) throws -> MovingObject {
    let key: String = val.key
    let type: String = val.type
    switch type {
    case "person":
      initPerson()
      return movableObjectPool[key] as! MovingObject
    default:
      throw IResolveError("Unexpected Value: \(type)")
    }
  }
  
  public static func cleanup() {
    IResolve.shared = nil
  }
}


struct IResolveError: Error {
    let message: String

    init(_ message: String) {
        self.message = message
    }

    public var localizedDescription: String {
        return message
    }
}
