//
//  AnswerBehavior.swift
//  jogo
//
//  Created by arham on 21/06/2021.
//

import Foundation
import RxSwift
import RxCocoa

internal class AnswerBehavior {
  
  typealias NoArgsMethod =  () -> Void
  
  final private var allMatch: [ObjectDetection] = [ObjectDetection]()
  final private var anyMatch: [ObjectDetection] = [ObjectDetection]()
  final private var onSuccessProcess: [NoArgsMethod] = [NoArgsMethod]()
  final private var onFailureProcess: [NoArgsMethod] = [NoArgsMethod]()
  
  public init() { }
  
  public func onSuccess() {
    onSuccessProcess.forEach { method in
      method()
    }
  }
  
  public func onFailure() {
    onFailureProcess.forEach { method in
      method()
    }
  }
  
  public func addAllMatch(objDet: ObjectDetection) {
    allMatch.append(objDet)
  }
  
  public func addAnyMatch(objDet: ObjectDetection) {
    anyMatch.append(objDet)
  }
  
  public func addOnSuccess(method: @escaping NoArgsMethod) {
    onSuccessProcess.append(method)
  }
  
  public func addOnFailure(method: @escaping NoArgsMethod) {
    onFailureProcess.append(method)
  }
  
  public func touched(answer: Answer) -> Bool {
    let allM: Bool = allMatched(answer: answer)
    let anyM: Bool = anyMatched(answer: answer)
    let ret: Bool = allM && anyM
    return ret
  }
  
  public func allMatched(answer: Answer) -> Bool {
    if allMatch.isEmpty {
      return true
    }
    let result: Bool = allMatch.map({ $0.getDetectedLocation() })
      .map({ $0 != nil && answer.touched(detectionLocation: $0!) })
      .allSatisfy({ $0 })
    return result
  }
  
  public func anyMatched(answer: Answer) -> Bool {
    if anyMatch.isEmpty {
      return true
    }
    
    var result: Bool = false
    for detLoc in anyMatch.map({ $0.getDetectedLocation() }) {
      let a: Bool = detLoc != nil && answer.touched(detectionLocation: detLoc!)
      if a {
        result = true
        break
      }
    }
    return result
  }
  
}
