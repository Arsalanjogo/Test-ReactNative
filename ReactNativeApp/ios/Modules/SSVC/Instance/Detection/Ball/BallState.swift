//
//  BallState.swift
//  jogo
//
//  Created by arham on 04/11/2021.
//

import Foundation


class BallState: ObjectDetectionState {
  
  public enum ORIENTATION {
      case LEFT
      case RIGHT
      case ANY
  }
  
  public enum AXIS: Int {
    case x = 1
    case y = 2
  }
  
  public enum BallDraw {
    case CIRCLE
    case RECT
    case POINT
    case TRAJECTORY
  }
  
  public static let LABEL: String = "ball"
  
  private var width: Double = 0
  private var height: Double = 0
  private var radius: Double = 0
  private var lastBounceId: Int = 0
  private var bounce: Bool?
  
  internal var DETERMINE_BOUNCE_RANGE: Int = 10
  internal var ballStats: BallStatistics?
  
  internal var  ballTrajectoryLength: Int = 8
  
  public static let MAX_RADIUS: Double = 0.20
  public static let MIN_RADIUS: Double = 0.05
  
  // MARK: Debug Variables
  public var low1pt: DetectionLocation?
  public var low2pt: DetectionLocation?
  public var highpt: DetectionLocation?
  
  public var isCalibrated: Bool = false
  
  init(modelType: ModelManager.MODELTYPE, exerciseLead: Bool, observerId: Int) {
    super.init(label: BallState.LABEL, modelType: modelType, exerciseLead: exerciseLead, observerId: observerId)
  }
  
  private func processExtraCheck(curDetLoc: DetectionLocation) -> Bool {
    let val: Double = curDetLoc.getRadius()
    return val < BallState.MAX_RADIUS && val > BallState.MIN_RADIUS
  }
  
  override func processCheck(curDetLoc: DetectionLocation, bestMatch: DetectionLocation?, lastLocation: DetectionLocation?, minDistance: Double) -> Bool {
    let value = super.processCheck(curDetLoc: curDetLoc, bestMatch: bestMatch, lastLocation: lastLocation, minDistance: minDistance)
    return value && processExtraCheck(curDetLoc: curDetLoc)
  }
  
  public override func parse(detectedLocations: [DetectionLocation], infoBlob: InfoBlob) {
    super.parse(detectedLocations: detectedLocations, infoBlob: infoBlob)
    let detLoc: DetectionLocation? = self.getLocation()
    if detLoc == nil { return }
    
    if detLoc!.getStatus() == .DETECTED {
      self.width = (self.width + Double((detLoc! as? RectLocation)?.getRectangle().width ?? 0 / 2.0)) / 2.0
      self.height = (self.height + Double((detLoc! as? RectLocation)?.getRectangle().height ?? 0 / 2.0)) / 2.0
      self.radius = (self.radius + detLoc!.getRadius()) / 2.0
    }
  }
  
  override func cleanup() {
    super.cleanup()
    self.low1pt = nil
    self.low2pt = nil
    self.highpt = nil
    // TODO: If we start using BallStatistics in the future, call the ballStats.cleanup() after creating that func in it.
    self.ballStats?.cleanup()
    self.ballStats = nil
  }
  
  // MARK: Properties Get/Set
  
  override public func getWidth() -> Double {
    return self.width
  }
  
  override public func getHeight() -> Double {
    return self.height
  }
  
  override public func getRadius() -> Double {
    return self.radius
  }
  
  internal func setLastBounceId(id: Int) {
    self.lastBounceId = id
  }
  
  internal func getLastBounceId() -> Int {
    return self.lastBounceId
  }
  
  internal func hasBounced() -> Bool {
    return self.bounce ?? false
  }
}
