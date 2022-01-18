//
//  BallStatistics.swift
//  jogo
//
//  Created by arham on 10/03/2021.
//

import Foundation

class BallStatistics: BaseStatistics {
  
  weak private var ball: BallDetection?
  var ballSpeeds: [Double] = [Double]()
  var stdDevX: Double?
  var stdDevY: Double?
  var totalDistance: Double = 0
  var totalTime: Double = 0
  var avgSpeed: Double = 0
  var maxSpeed: Double = 0
  var currentDistance: Double = 0
  var currentTime: Double = 0
  var minimumDistance: Double = 0.01
  var SPEED_RANGE: Int = 20
  var rescaledPoints: [(Double, Double)] = [(Double, Double)]()
  
  var ballLocations: UtilArrayList<DetectionLocation>? = UtilArrayList<DetectionLocation>()
  
  // MARK: Lifecycle
  init(ball: BallDetection, score: BaseScore, infoBlobArrayList: UtilArrayList<InfoBlob>) {
    self.ball = ball
    super.init(score: score, infoBlobArrayList: infoBlobArrayList)
  }
  
  
  public override func cleanup() {
    self.ball = nil
    self.ballLocations?.clear()
    self.ballLocations = nil
  }
  
  // MARK: Properties Get/Set
  public func getMaxSpeed() -> Double {
    return self.maxSpeed
  }
  
  // MARK: Calculate Properties
  public func getAverageSpeed() -> Double {
    self.avgSpeed = self.totalDistance / self.totalTime
    self.avgSpeed = Double(Int(self.avgSpeed * 100.0) / 100)
    return self.avgSpeed
  }
  
  public func getCurrentFrameSpeed() -> Double {
    if self.infoBlobArrayList.count() < SPEED_RANGE {
      return 0.0
    }
    self.currentDistance = 0.0
    self.currentTime = 0.0
    
    let startValue = self.infoBlobArrayList.count() - 2
    let endValue = self.infoBlobArrayList.count() - SPEED_RANGE
    for frameIndex in stride(from: startValue, to: endValue, by: -1) {
      let prevFrameId: Int = frameIndex - 1
      do {
        let prevBallLocation: DetectionLocation = try self.ballLocations!.get(index: prevFrameId)
        let curBallLocation: DetectionLocation = try self.ballLocations!.get(index: frameIndex)
        if prevBallLocation.locationKnown() && curBallLocation.locationKnown() {
          let distance: Double = curBallLocation.getEuclideanDistance(location: prevBallLocation)
          if distance > self.minimumDistance {
            self.currentDistance += distance
            let curTime: UInt64 = try infoBlobArrayList.get(index: frameIndex).startTime
            let prevTime: UInt64 = try infoBlobArrayList.get(index: prevFrameId).startTime
            let time: Double = Double(curTime - prevTime ) / 1000
            currentTime += time
          }
        }
      } catch {}
    }
    if currentDistance != 0.0 && currentTime != 0.0 {
      var currentSpeed: Double = currentDistance / currentTime
      currentSpeed = Double(Int(currentSpeed * 100.0) / 100)
      return currentSpeed
    }
    return 0.0
  }
  
  public func processSpeedCalculations() {
    if score!.scoreFrameIds.isEmpty { return }
    let currentFrameId: Int = infoBlobArrayList.count() - 1
    let prevFrameId: Int = currentFrameId - 1
    do {
      let curBallLocation: DetectionLocation = try self.ballLocations!.get(index: currentFrameId)
      let prevBallLocaiton: DetectionLocation = try self.ballLocations!.get(index: prevFrameId)
      if curBallLocation.locationKnown() && prevBallLocaiton.locationKnown() {
        let distance: Double = curBallLocation.getEuclideanDistance(location: prevBallLocaiton)
        if distance > minimumDistance {
          totalDistance += distance
          let curTime: UInt64 = try infoBlobArrayList.get(index: currentFrameId).startTime
          let prevTime: UInt64 = try infoBlobArrayList.get(index: prevFrameId).startTime
          let time: Double = Double(curTime - prevTime ) / 1000
          totalTime += time
          maxSpeed = Double(Int(max(maxSpeed, (distance / time)) * 100.0) / 100)
          ballSpeeds.append(maxSpeed)
        }
      }
    } catch {
      
    }
  }

  public func calculateStdDev() {
    let ballLocation: UtilArrayList<DetectionLocation> = ball!.getLocations()
    
    for i in 0...(score!.scoreFrameIds.count - 1) {
      let scoreFrameId: (Int, Int) = score!.scoreFrameIds[i]
      if scoreFrameId.1 > 0 {
        rescalePoints(idx: i, scoreFrameIds: score!.scoreFrameIds, ballLocations: ballLocation)
      }
      
      let rescaledMeanXY: (Double, Double) = getMeanXY(rescaledPoints: rescaledPoints)
      let rescaledListSize: Int = rescaledPoints.count - 1
      var stdDexX: Double = 0
      var stdDevY: Double = 0
      
      rescaledPoints.forEach { point in
        stdDexX += pow(point.0 - rescaledMeanXY.0, 2)
        stdDevY += pow(point.1 - rescaledMeanXY.1, 2)
      }
      self.stdDevX = sqrt(stdDexX / Double(rescaledListSize))
      self.stdDevY = sqrt(stdDevY / Double(rescaledListSize))
    }
  }
  
  private func getMeanXY(ballLocations: UtilArrayList<DetectionLocation>) -> (Double, Double) {
    var sumX: Double = 0
    var sumY: Double = 0
    let ballCount = ballLocations.count()
    
    ballLocations.get().forEach { (detLoc) in
      sumX += detLoc.getX()
      sumY += detLoc.getY()
    }
    return (sumX / Double(ballCount), sumY / Double(ballCount))
  }
  
  private func getMeanXY(rescaledPoints: [(Double, Double)]) -> (Double, Double) {
    var sumX: Double = 0
    var sumY: Double = 0
    let ballCount = ballLocations!.count()
    rescaledPoints.forEach { point in
      sumX += point.0
      sumY += point.1
    }
    return (sumX / Double(ballCount), sumY / Double(ballCount))
  }
  
  public func rescalePoints(idx: Int,
                            scoreFrameIds: [(Int, Int)],
                            ballLocations: UtilArrayList<DetectionLocation>) {
    
    let currentFrameId: Int = scoreFrameIds[idx].0
    let nextFrameId: Int = scoreFrameIds[idx + 1].0
    
    let localBallLocations: UtilArrayList<DetectionLocation> = UtilArrayList(values:
                                                                              ballLocations.get().filter { (detLoc) -> Bool in
                                                                                return detLoc.locationKnown() &&
                                                                                  detLoc.getFrameId() >= currentFrameId &&
                                                                                  detLoc.getFrameId() < nextFrameId
                                                                              })
    let meanXY: (Double, Double) = getMeanXY(ballLocations: localBallLocations)
    localBallLocations.get().forEach { (detLoc) in
      let rescaledX: Double = detLoc.getX() - meanXY.0
      let rescaledY: Double = detLoc.getY() - meanXY.1
      rescaledPoints.append((rescaledX, rescaledY))
    }
  }
  
  override func writeStatsToJSON() {
  }
}
