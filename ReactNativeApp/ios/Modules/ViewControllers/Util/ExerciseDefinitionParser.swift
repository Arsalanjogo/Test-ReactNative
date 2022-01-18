//
//  ExerciseDefinitionParser.swift
//  jogo
//
//  Created by arham on 20/10/2021.
//

import Foundation
import RxSwift


var MapObjectDetection: [String: EnumObjectDetection] = [
  "person": .Person,
  "ball": .Ball
]

typealias modelObjectRelation = (objectDetection: EnumObjectDetection?, modelType: ModelManager.MODELTYPE)


class ExerciseDefinitionParser {
  
  
  
  private var exerciseDefinition: _ExerciseDefiniton?
  private var exerciseFileName: String
  
  
  
  init(fileName: String) {
    exerciseFileName = fileName
    exerciseDefinition = self.loadJson()
  }
  
  private func loadJson() -> _ExerciseDefiniton? {
     let decoder = JSONDecoder()
     guard
          let url = Bundle.main.url(forResource: exerciseFileName, withExtension: "json"),
          let data = try? Data(contentsOf: url),
          let eDef = try? decoder.decode(_ExerciseDefiniton.self, from: data)
     else {
          return nil
     }
     return eDef
  }
  
  public func changeFile(fileName: String) {
    exerciseFileName = fileName
    exerciseDefinition = self.loadJson()
  }
  
  public func getDefinition() -> _ExerciseDefiniton? {
    return self.exerciseDefinition
  }
  
  public func getObjectsToUse() -> [modelObjectRelation] {
    var objModelRel: [modelObjectRelation] = [modelObjectRelation]()
    
    self.exerciseDefinition?.metadata.objectsNeeded.forEach({ objNeed in
      let intermediate: modelObjectRelation = self.getObjectDetection(odType: objNeed.type, variation: objNeed.variation)
      if intermediate.objectDetection != nil {
        objModelRel.append(intermediate)
      }
    })
    return objModelRel
  }
  
  private func getObjectDetection(odType: String, variation: String) -> modelObjectRelation {
    guard let modelType: EnumObjectDetection = MapObjectDetection[odType] else { return (nil, .SKIP) }
    switch modelType {
    case .Person:
      switch variation {
      case "heavy":
        return (.Person, .POSENET)
      case "normal":
        return (.Person, .POSENET)
      case "fast":
        return (.Person, .POSENETFAST)
      default:
        return (.Person, .POSENET)
      }
    case .Ball:
      switch variation {
      case "heavy":
        return (.Ball, .FOOTBALLvCNET)
      case "normal":
        return (.Ball, .FOOTBALLv16)
      case "fast":
        return (.Ball, .FOOTBALLv16)
      default:
        return (.Ball, .FOOTBALLv16)
      }
    }
  }
  
}
