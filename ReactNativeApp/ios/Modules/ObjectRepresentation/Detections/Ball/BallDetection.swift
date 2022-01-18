//
//  BallDetection.swift
//  jogo
//
//  Created by arham on 10/03/2021.
//

import Foundation

class BallDetection: ObjectDetection {
  // Ball Representation of the TFLilte Detection model.
  
  public static let LABEL: String = "ball"
  private var width: Double = 0
  private var height: Double = 0
  private var radius: Double = 0
  private var lastBounceId: Int = 0
  private var bounce: Bool?
  
  var DETERMINE_BOUNCE_RANGE: Int = 10
  var ballStats: BallStatistics?
  
  public enum ORIENTATION {
    case LEFT
    case RIGHT
    case ANY
  }
  
  public enum AXIS: Int {
    case x = 1
    case y = 2
  }
  
  public static let MAX_RADIUS: Double = 0.35
  public static let MIN_RADIUS: Double = 0.05
  
  // MARK: Debug Variables
  public var low1pt: DetectionLocation?
  public var low2pt: DetectionLocation?
  public var highpt: DetectionLocation?
  
  // MARK: Lifecycle
  init(modelType: ModelManager.MODELTYPE, exerciseLead: Bool, observerId: Int) {
    super.init(label: BallDetection.LABEL, modelType: modelType, exerciseLead: exerciseLead, observerId: observerId)
    self.initializationSteps()
  }
  
  init(exerciseLead: Bool, observerId: Int) {
    super.init(label: BallDetection.LABEL, modelType: ModelManager.MODELTYPE.FOOTBALLv16, exerciseLead: exerciseLead, observerId: observerId)
    self.initializationSteps()
  }
  
  private func initializationSteps() {
    //    self.ballStats = BallStatistics(ball: self, score: BaseExercise.getExercise()!.score!, infoBlobArrayList: getInfoBlobArrayList())
  }
  
  public override func parse(detectedLocations: [DetectionLocation], infoBlob: InfoBlob) {
    super.parse(detectedLocations: detectedLocations, infoBlob: infoBlob)
    let detLoc: DetectionLocation? = self.getLocation()
    if detLoc == nil { return }
    
    if detLoc!.getRadius() > BallDetection.MAX_RADIUS && detLoc!.getRadius() < BallDetection.MIN_RADIUS {
      return
    }
    
    if detLoc!.getStatus() == .DETECTED {
      self.width = (self.width + Double((detLoc! as? RectLocation)?.getRectangle().width ?? 0 / 2.0)) / 2.0
      self.height = (self.height + Double((detLoc! as? RectLocation)?.getRectangle().height ?? 0 / 2.0)) / 2.0
      self.radius = (self.radius + detLoc!.getRadius()) / 2.0
    }
  }
  
  // MARK: Properties Get/Set
  public func getWidth() -> Double {
    return self.width
  }
  
  public func getHeight() -> Double {
    return self.height
  }
  
  public override func getInfoBlobArrayList() -> UtilArrayList<InfoBlob> {
    return infoBlobArrayList
  }
  
  // MARK: Calculate Properties
  
  public func getMaxSpeed() -> Double {
    return ballStats!.getMaxSpeed()
  }
  
  public func getAvgSpeed() -> Double {
    return ballStats!.getAverageSpeed()
  }
  
  public func getCurrentSpeed() -> Double {
    return ballStats!.getCurrentFrameSpeed()
  }
  
  public func determineBounce(low1: DetectionLocation, high: DetectionLocation, low2: DetectionLocation, axis: AXIS) -> Bool {
    let threshold: Double = min(self.getHeight(), self.getWidth()) / 1.5
    switch axis {
    case .x:
      return (abs(high.getX() - low1.getX()) > threshold) && (abs(high.getX() - low2.getX()) > threshold)
    case .y:
      return (abs(high.getY() - low1.getY()) > threshold) && (abs(high.getY() - low2.getY()) > threshold)
    }
  }
  
  public func didBounce(orientation: ORIENTATION, frameId: Int, axis: AXIS) -> Int {
    var bounce: Bool = false
    
    var ballLocations: UtilArrayList<DetectionLocation>? = self.getNLocations(locationCount: DETERMINE_BOUNCE_RANGE)
    if ballLocations == nil { return frameId }
    
    ballLocations = UtilArrayList(values: ballLocations!.get().filter({ (detLoc: DetectionLocation) -> Bool in
      detLoc.locationKnown()
    }).filter({ (detLoc: DetectionLocation) -> Bool in
      detLoc.getFrameId() > frameId
    }))
    
    if ballLocations!.isEmpty() { return frameId }
    
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
        if highIndex + 1 >= ballLocations!.count() { return frameId }
        
        ballLow1Locations = UtilArrayList<DetectionLocation>(values: Array(ballLocations!.get()[0...highIndex]))
        ballLow2Locations = UtilArrayList<DetectionLocation>(values: Array(ballLocations!.get()[(highIndex + 1)...(ballLocations!.count() - 1)]))
        
        low1 = ballLow1Locations.getMin(comparator: { (det1: DetectionLocation, det2: DetectionLocation) -> Bool in
          det1.getX() < det2.getX()
        })
        low2 = ballLow2Locations.getMin(comparator: { (det1: DetectionLocation, det2: DetectionLocation) -> Bool in
          det1.getX() < det2.getX()
        })
        if low1 == nil || low2 == nil { return frameId }
        bounce = determineBounce(low1: low1!, high: high!, low2: low2!, axis: axis)
        if bounce {
          lastBounceId = high!.getFrameId()
          self.low1pt = low1!
          self.highpt = high!
          self.low2pt = low2!
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
        if (lowIndex + 1) >= ballLocations!.count() { return frameId }
        
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
          lastBounceId = low!.getFrameId()
          self.low1pt = high1!
          self.highpt = low!
          self.low2pt = high2!
        }
      }
      return lastBounceId
    case .y:
      lastBounceId = frameId
      var high1, low, high2: DetectionLocation?
      var lowIndex: Int
      
      var ballHigh1Locations: UtilArrayList<DetectionLocation>
      var ballHigh2Locations: UtilArrayList<DetectionLocation>
      
      low = ballLocations!.getMin(comparator: { (det1: DetectionLocation, det2: DetectionLocation) -> Bool in
        det1.getY() < det2.getY()
      })!
      lowIndex = ballLocations!.get().firstIndex(where: { (detLoc: DetectionLocation) -> Bool in
        detLoc === low
      })!
      if (lowIndex + 1) >= ballLocations!.count() { return frameId }
      
      ballHigh1Locations = UtilArrayList<DetectionLocation>(values: Array(ballLocations!.get()[0...lowIndex]))
      ballHigh2Locations = UtilArrayList<DetectionLocation>(values: Array(ballLocations!.get()[(lowIndex + 1)...(ballLocations!.count() - 1)]))
      
      high1 = ballHigh1Locations.getMax(comparator: { (det1: DetectionLocation, det2: DetectionLocation) -> Bool in
        det1.getY() < det2.getY()
      })
      high2 = ballHigh2Locations.getMax(comparator: { (det1: DetectionLocation, det2: DetectionLocation) -> Bool in
        det1.getY() < det2.getY()
      })
      
      if high1 == nil || high2 == nil { return frameId }
      bounce = determineBounce(low1: high1!, high: low!, low2: high2!, axis: axis)
      if bounce {
        lastBounceId = low!.getFrameId()
        self.low1pt = high1!
        self.highpt = low!
        self.low2pt = high2!
      }
    }
    return lastBounceId
  }
  
  // MARK: Draw functionality
  override public func drawDebug(canvas: UIView) {
    let location: DetectionLocation? = self.getDetectedLocation()
    if location == nil { return }
    
    DrawingManager.get().drawCircle(view: canvas, center: CGPoint(x:location!.getX(), y: location!.getY()), with: CGFloat(self.radius), lineWidth: 4, color: ThemeManager.shared.theme.primaryColor, hollow: true)
  }
  
  override public func draw(canvas: UIView) {
    
  }
  
}
