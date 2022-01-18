//
//  PointsState.swift
//  jogo
//
//  Created by Mohsin on 13/10/2021.
//

import Foundation
import RxRelay
import RxSwift

public class PointsState: State {
  
  let DEFAULT_POINTS: Int = 0
  let currentPoints: BehaviorRelay<Int>
  /// (location of last point,  isNegatve)
  let lastPoint: PublishRelay<(DetectionLocation, Bool)>
  var points: [(Int, Double)] = []
  let animationSettings: Int = 1
  var animationPoints: Int = 0
  
  // MARK: RENDER PROPERTIES:
  let deviceX: Double = 0.2
  let deviceY: Double = 0.8
  
  override init() {
    self.currentPoints = BehaviorRelay(value: DEFAULT_POINTS)
    self.lastPoint = PublishRelay()
  }
  
//  private func setPointsInternal(amount: Int) {
//    self.points.append((amount, Date().getMilliseconds()))
//    self.currentPoints = amount
//    notifyObservers()
//  }
//
//  public func incrementPoints(value: Int) {
//    setPointsInternal(amount: value + currentPoints)
//  }
//
//  public func decrementPoints(value: Int) {
//    setPointsInternal(amount: value - currentPoints)
//  }
//
//  public func resetPoints() {
//    setPointsInternal(amount: DEFAULT_POINTS)
//  }
//
//  public func setPoints(amount: Int) {
//    setPointsInternal(amount: amount)
//  }
//
//  public func getPoints() -> Int {
//    return currentPoints
//  }
  
  override public func getDebugText() -> String {
    return String(currentPoints.value)
  }
}
