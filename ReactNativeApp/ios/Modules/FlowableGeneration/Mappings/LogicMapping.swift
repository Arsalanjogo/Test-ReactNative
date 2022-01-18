//
//  LogicMapping.swift
//  jogo
//
//  Created by arham on 21/10/2021.
//

import Foundation


class LogicMapping {
  typealias FlowableMap = [String: BaseLogic.Type]
  
  static let numeric: FlowableMap = [
    "x": fGetXCalculator.self,
    "y": fGetYCalculator.self,
    "max": fMaxCalculator.self,
    "min": fMinCalculator.self,
    "ceil": fCeilCalculator.self,
    "multiply": fMultiplyCalculator.self,
    "property": fPropertyCalculator.self,
    "increment": fIncrementCalculator.self,
    "number": fNumberTrigger.self,
    "numberCalculator": fNumberCalculator.self
  ]
  static let logic: FlowableMap = [
    "greaterThan": fGreaterThanCalculator.self,
    "lesserThan": fLesserThanCalculator.self,
    "and": fAndCalculator.self,
    "or": fOrCalculator.self,
  ]
  
  static let object: FlowableMap = [
    "ankle": fAnkleTrigger.self,
    "knee": fKneeTrigger.self,
    "bottom": fBallBottomTrigger.self,
    "didBounce": fDidBounceTrigger.self,
    "didJump": fDidJumpTrigger.self,
    "groundLine": fGroundLineTrigger.self,
    "ball": fBallTrigger.self,
    "bounce": fBounceCalculator.self,
    "intersect": fIntersectsCalculator.self,
  ]
  static let action: FlowableMap = [
    "score": fScoreAction.self,
    "setGlobal": fSetGlobalAction.self,
    "getLevel": fGetLevelTrigger.self,
    "timer": fTimerTrigger.self,
  ] 
  
  static let logicMapping: [String: FlowableMap] = [
    "numeric": LogicMapping.numeric,
    "logic": LogicMapping.logic,
    "object": LogicMapping.object,
    "action": LogicMapping.action,
  ]
  
  static func get(type: String, subtype: String) -> BaseLogic.Type {
    return LogicMapping.logicMapping[type]![subtype]!
  }
  
}
