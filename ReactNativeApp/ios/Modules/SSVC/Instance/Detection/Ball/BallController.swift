//
//  BallController.swift
//  jogo
//
//  Created by arham on 04/11/2021.
//

import Foundation

class BallController: Controller {
  
  private var ballState: BallState?
  
  init(state: BallState) {
    super.init(state: state)
    self.ballState = state
  }
  
  override func cleanup() {
    self.ballState?.removeObservers()
    self.ballState = nil
  }
  
  public func changeCalibrationStatus(isCalibrated: Bool) {
    ballState?.isCalibrated = isCalibrated
  }
  
  public func determineBounce(low1: DetectionLocation, high: DetectionLocation, low2: DetectionLocation, axis: BallState.AXIS) -> Bool {
    let threshold: Double = min(self.ballState?.getHeight() ?? 0, self.ballState?.getWidth() ?? 0) / 1.5
    switch axis {
    case .x:
      return (abs(high.getX() - low1.getX()) > threshold) && (abs(high.getX() - low2.getX()) > threshold)
    case .y:
      return (abs(high.getY() - low1.getY()) > threshold) && (abs(high.getY() - low2.getY()) > threshold)
    }
  }
  
  public func didBounce(orientation: BallState.ORIENTATION, frameId: Int, axis: BallState.AXIS) -> Int {
    let stime: Double = Date().getMilliseconds()
    var bounce: Bool = false
    
    var ballLocations: UtilArrayList<DetectionLocation>? = self.ballState!.getNLocations(locationCount: self.ballState?.DETERMINE_BOUNCE_RANGE ?? 1)
    if ballLocations == nil {
      Profiler.get().profileTime(frameId: frameId, tag: "Ball-\(#function)-false", delta: Date().getMilliseconds() - stime)
      return -1 }
    
    ballLocations = UtilArrayList(values: ballLocations!.get().filter({ (detLoc: DetectionLocation) -> Bool in
      detLoc.locationKnown()
    }).filter({ (detLoc: DetectionLocation) -> Bool in
      detLoc.getFrameId() > frameId
    }))
    
    if ballLocations!.isEmpty() {
      Profiler.get().profileTime(frameId: frameId, tag: "Ball-\(#function)-false", delta: Date().getMilliseconds() - stime)
      return -1 }
    
    switch axis {
    case .x:
      if orientation == .LEFT || orientation == .ANY {
        var low1, high, low2: DetectionLocation?
        var highIndex: Int
        
        var ballLow1Locations: UtilArrayList<DetectionLocation>
        var ballLow2Locations: UtilArrayList<DetectionLocation>
        
        high = ballLocations!.getMax(comparator: { (det1: DetectionLocation, det2: DetectionLocation) -> Bool in
          det1.getX() < det2.getX()
        })!
        highIndex = ballLocations!.get().firstIndex(where: { (detLoc: DetectionLocation) -> Bool in
          detLoc === high
        })!
        if highIndex + 1 >= ballLocations!.count() {
          Profiler.get().profileTime(frameId: frameId, tag: "Ball-\(#function)-false", delta: Date().getMilliseconds() - stime)
          return -1 }
        
        ballLow1Locations = UtilArrayList<DetectionLocation>(values: Array(ballLocations!.get()[0...highIndex]))
        ballLow2Locations = UtilArrayList<DetectionLocation>(values: Array(ballLocations!.get()[(highIndex + 1)...(ballLocations!.count() - 1)]))
        
        low1 = ballLow1Locations.getMin(comparator: { (det1: DetectionLocation, det2: DetectionLocation) -> Bool in
          det1.getX() < det2.getX()
        })
        low2 = ballLow2Locations.getMin(comparator: { (det1: DetectionLocation, det2: DetectionLocation) -> Bool in
          det1.getX() < det2.getX()
        })
        if low1 == nil || low2 == nil {
          Profiler.get().profileTime(frameId: frameId, tag: "Ball-\(#function)-false", delta: Date().getMilliseconds() - stime)
          return -1 }
        bounce = determineBounce(low1: low1!, high: high!, low2: low2!, axis: axis)
        if bounce {
          self.ballState?.setLastBounceId(id: high!.getFrameId())
          self.ballState!.low1pt = low1!
          self.ballState!.highpt = high!
          self.ballState!.low2pt = low2!
        }
      }
      if orientation == .RIGHT || orientation == .ANY {
        var high1, low, high2: DetectionLocation?
        var lowIndex: Int
        
        var ballHigh1Locations: UtilArrayList<DetectionLocation>
        var ballHigh2Locations: UtilArrayList<DetectionLocation>
        
        low = ballLocations!.getMin(comparator: { (det1: DetectionLocation, det2: DetectionLocation) -> Bool in
          det1.getX() < det2.getX()
        })!
        lowIndex = ballLocations!.get().firstIndex(where: { (detLoc: DetectionLocation) -> Bool in
          detLoc === low
        })!
        if (lowIndex + 1) >= ballLocations!.count() {
          Profiler.get().profileTime(frameId: frameId, tag: "Ball-\(#function)-false", delta: Date().getMilliseconds() - stime)
          return -1 }
        
        ballHigh1Locations = UtilArrayList<DetectionLocation>(values: Array(ballLocations!.get()[0...lowIndex]))
        ballHigh2Locations = UtilArrayList<DetectionLocation>(values: Array(ballLocations!.get()[(lowIndex + 1)...(ballLocations!.count() - 1)]))
        
        high1 = ballHigh1Locations.getMax(comparator: { (det1: DetectionLocation, det2: DetectionLocation) -> Bool in
          det1.getX() < det2.getX()
        })
        high2 = ballHigh2Locations.getMax(comparator: { (det1: DetectionLocation, det2: DetectionLocation) -> Bool in
          det1.getX() < det2.getX()
        })
        
        if high1 == nil || high2 == nil { return frameId }
        bounce = determineBounce(low1: high1!, high: low!, low2: high2!, axis: axis)
        if bounce {
          self.ballState?.setLastBounceId(id: low!.getFrameId())
          self.ballState!.low1pt = high1!
          self.ballState!.highpt = low!
          self.ballState!.low2pt = high2!
        }
      }
      Profiler.get().profileTime(frameId: frameId, tag: "Ball-\(#function)-true", delta: Date().getMilliseconds() - stime)
      return self.ballState!.getLastBounceId()
    case .y:
      self.ballState!.setLastBounceId(id: frameId)
      var high1, low, high2: DetectionLocation?
      var lowIndex: Int
      
      var ballHigh1Locations: UtilArrayList<DetectionLocation>
      var ballHigh2Locations: UtilArrayList<DetectionLocation>
      
      low = ballLocations!.getMax(comparator: { (det1: DetectionLocation, det2: DetectionLocation) -> Bool in
        det1.getY() < det2.getY()
      })!
      lowIndex = ballLocations!.get().firstIndex(where: { (detLoc: DetectionLocation) -> Bool in
        detLoc === low
      })!
      if (lowIndex + 1) >= ballLocations!.count() {
        Profiler.get().profileTime(frameId: frameId, tag: "Ball-\(#function)-false", delta: Date().getMilliseconds() - stime)
        return -1
      }
      
      ballHigh1Locations = UtilArrayList<DetectionLocation>(values: Array(ballLocations!.get()[0...lowIndex]))
      ballHigh2Locations = UtilArrayList<DetectionLocation>(values: Array(ballLocations!.get()[(lowIndex + 1)...(ballLocations!.count() - 1)]))
      
      high1 = ballHigh1Locations.getMin(comparator: { (det1: DetectionLocation, det2: DetectionLocation) -> Bool in
        det1.getY() < det2.getY()
      })
      high2 = ballHigh2Locations.getMin(comparator: { (det1: DetectionLocation, det2: DetectionLocation) -> Bool in
        det1.getY() < det2.getY()
      })
      
      if high1 == nil || high2 == nil {
        Profiler.get().profileTime(frameId: frameId, tag: "Ball-\(#function)-false", delta: Date().getMilliseconds() - stime)
        return -1
      }
      bounce = determineBounce(low1: high1!, high: low!, low2: high2!, axis: axis)
      if bounce {
        self.ballState!.setLastBounceId(id: low!.getFrameId())
        self.ballState!.low1pt = high1!
        self.ballState!.highpt = low!
        self.ballState!.low2pt = high2!
      }
    }
    Profiler.get().profileTime(frameId: frameId, tag: "Ball-\(#function)-true", delta: Date().getMilliseconds() - stime)
    return self.ballState!.getLastBounceId()
  }
  

  
  public func getNDetectionLocations(locationCount: Int) -> UtilArrayList<DetectionLocation>? {
    return self.ballState?.getNDetectionLocations(locationCount: locationCount)
  }
  
  public func getKnownLastN(locationCount: Int) -> UtilArrayList<DetectionLocation>? {
    return self.ballState?.getKnownLastN(locationCount: locationCount)
  }
  
  public func getHeight() -> Double? {
    return self.ballState?.getHeight()
  }
  
  public func getWidth() -> Double? {
    return self.ballState?.getWidth()
  }
  
  public func getRadius() -> Double? {
    return self.ballState?.getRadius()
  }
  
  public func getBallBounceRange() -> Int {
    return self.ballState?.DETERMINE_BOUNCE_RANGE ?? 10
  }
  
  public func getBallState() -> BallState {
    return self.ballState!
  }
}
