//
//  DribblingLocation.swift
//  jogo
//
//  Created by arham on 18/05/2021.
//

import Foundation

class DribblingLocation: MovingLocation {
  // Location used for the ball to reach and intersect with.
  
  enum STATUS: String {
    case ACTIVE = "Active"
    case RESOLVE = "Resolve"
    case INACTIVE = "Inactive"
  }
  
  private var status: STATUS = .INACTIVE
  
  private var radius: Double
  private var MINLEFT: Double
  private var MAXRIGHT: Double
  
  private let LEFTCONE: Double = 0.05
  private let RIGHTCONE: Double = 0.95
  
  private let timer: TimerUtil
  
  public var resolutionTime: Double = 0
  public let GROWTIME: Double = 300
  public let MAXMULTIPLIER: Double = 1.5
  
  // MARK: Lifecycle
  init(ballradius: Double, centerX: Double, centerY: Double, timerUtil: TimerUtil) {
    radius = ballradius
    MINLEFT = radius * 1.5
    MAXRIGHT = 1 - MINLEFT
    timer = timerUtil
    super.init(x: centerX, y: centerY)
  }
  
  required init(from decoder: Decoder) throws {
    fatalError("init(from:) has not been implemented")
  }
  
  // MARK: Internal Logic
  
  public func activate() -> DribblingLocation {
    self.status = .ACTIVE
    return self
  }
  
  private func finalizeResolve() {
    status = status == .RESOLVE ? .INACTIVE : status
  }
  
  public func resolve() {
    resolutionTime = Date().getMilliseconds()
    status = .RESOLVE
    do {
      _ = try timer.schedule(runnable: finalizeResolve, delay: GROWTIME)
    } catch {
      Logger.shared.logError(logType: .ERROR, error: error)
    }
  }
  
  public func updateXLocationRandom(prevX: Double) {
    self.setX(value: getRandomX(prevX: prevX))
  }
  
  public func getRandomX(prevX: Double) -> Double {
    let randMultiplier: Double = drand48()
    var newLocation: Double
    
    let distanceLeftCone: Double = prevX - LEFTCONE
    let distanceRightCone: Double = RIGHTCONE - prevX
    
    if distanceLeftCone > distanceRightCone {
      newLocation = MINLEFT + (((prevX - (radius * 3.3)) - MINLEFT) * randMultiplier)
    } else {
      newLocation = (prevX + (radius * 3.3)) + ((MAXRIGHT - (prevX + (radius * 3.3))) * randMultiplier)
    }
    return newLocation
  }
  
  // MARK: Properties Get/Set
  public func isActive() -> Bool {
    return status == .ACTIVE
  }
  
  public override func getRadius() -> Double {
    return radius
  }
  
  public func setRadius(radius: Double) {
    self.radius = radius
  }
  
  public override func toString() -> String {
    return "DribblingLocation{radius=\(radius), status=\(status.rawValue), resolutionTime=\(resolutionTime), x=\(self.getX()), y=\(self.getY())}"
  }
  
  // MARK: Drawing
  override func drawDebug(canvas: UIView) {
    
  }
  
  override func draw(canvas: UIView) {
    var multiplier: Double = 1
    switch status {
    case .ACTIVE:
      break
    case .INACTIVE:
      break
    case .RESOLVE:
      multiplier = min(MAXMULTIPLIER, MAXMULTIPLIER * ((Date().getMilliseconds() - resolutionTime) / GROWTIME))
    }
    
//    DrawingManager.shared.drawCircle(view: canvas, center: CGPoint(x: CGFloat(self.getX()), y: CGFloat(self.getY())), with: self.radius, lineWidth: 4, color: ThemeManager.shared.theme.primaryColor, hollow: true)
  }
}
