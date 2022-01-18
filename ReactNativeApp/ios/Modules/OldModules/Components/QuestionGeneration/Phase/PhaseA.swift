//
//  Phase.swift
//  jogo
//
//  Created by arham on 21/06/2021.
//

import Foundation

class PhaseA: Hashable, Equatable {
  
  private static var phasesId: Int = 99123
  private var creationTime: Int
  private var phaseId: Int
  typealias Consumer = () -> Void
  typealias DrawConsumer = (UIView) -> Void
  
  private var drawMethod: DrawConsumer?
  private var drawDebugMethod: DrawConsumer?
  var phaseFinishiedPredicate: Consumer?
  
  internal var phaseTime: Double?
  internal var phaseStartTime: Double?
  
  private var onPhaseStartMethod: Consumer?
  private var onProcessMethod: Consumer?
  private var onEndProcessMethod: Consumer?
  
  private static func getPhaseId() -> Int {
    let intermediate: Int = PhaseA.phasesId
    PhaseA.phasesId += 1
    return intermediate
  }
  
  public init(draw: DrawConsumer? = nil, drawDebug: DrawConsumer? = nil, phaseTime: Double? = nil, phaseStartTime: Double? = nil, phaseFinishedPredicate: Consumer? = nil) {
    self.drawMethod = draw
    self.drawDebugMethod = drawDebug
    self.phaseTime = phaseTime
    self.phaseStartTime = phaseStartTime
    self.phaseFinishiedPredicate = phaseFinishedPredicate
    self.creationTime = Int(Date().getNanoseconds())
    self.phaseId = PhaseA.getPhaseId()
  }
    
  public func start() {
    onPhaseStartMethod?()
    phaseStartTime = Date().getMilliseconds()
  }
  
  public func stop() {
    onEndProcessMethod?()
  }
  
  public func onStart(onPhaseStart: @escaping Consumer) -> PhaseA {
    self.onPhaseStartMethod = onPhaseStart
    return self
  }
  
  public func onProcess(onProcessFunc: @escaping Consumer) -> PhaseA {
    self.onProcessMethod = onProcessFunc
    return self
  }
  
  public func onEnd(onEndFunc: @escaping Consumer) -> PhaseA {
    self.onEndProcessMethod = onEndFunc
    return self
  }
  
  public func process() {
    onProcessMethod?()
  }
  
  public func phaseFinished() -> Bool {
    phaseFinishiedPredicate?()
    return phaseTime! < ((Date().getMilliseconds()) - phaseStartTime!)
  }
  
  public func setPhaseTime(time: Double) {
    self.phaseTime = time
  }
  
  public func draw(canvas: UIView) {
    drawMethod?(canvas)
  }
  
  public func drawDebug(canvas: UIView) {
    drawDebugMethod?(canvas)
  }
  
  // MARK: Hashable
  var hashValue: Int {
    return self.phaseId
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(self.phaseId)
  }
  
  static func == (lhs: PhaseA, rhs: PhaseA) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
