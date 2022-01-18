//
//  PersonController.swift
//  jogo
//
//  Created by Mohsin on 18/10/2021.
//

import Foundation

public class PersonController: Controller {
  
  public var highestLeftAnkle: DetectionLocation?
  public var highestRightAnkle: DetectionLocation?
  public var lowestLeftHeel: DetectionLocation?
  public var lowestRightHeel: DetectionLocation?
  public var lowestHighLeftHeel: DetectionLocation?
  public var lowestHighRightHeel: DetectionLocation?
  
  let JUMP_LOOKBACK = 30
  let GROUND_LOOKBACK: Int = 6
  let HEAD_LOOKBACK: Int = 6
  let MIN_JUMP: Double = 0.08
  let MIN_JUMP_FRAME_DISTANCE: Int = 5
  
  var personState: PersonState?
  
  private var groundLine: Double = 0
  
  init(state: PersonState) {
    super.init(state: state)
    self.personState = state
  }
  
  public func didJump(lastJumpFrameId: Int) -> Int {
    let stime: Double = Date().getMilliseconds()
    if personState!.getInfoBlobArrayList().count() < JUMP_LOOKBACK { return 0 }
    var lastFrameId: Int
    do {
      lastFrameId = try personState!.getInfoBlobArrayList().getLast()!.frameId!
    } catch {
      Logger.shared.logError(logType: .ERROR, error: error)
      Profiler.get().profileTime(frameId: lastJumpFrameId, tag: "Person-\(#function)-false", delta: Date().getMilliseconds() - stime)
      return 0 }
    
    let leftHeels = personState!.leftLeg!.heel.getNDetectionLocations(locationCount: min(JUMP_LOOKBACK, lastFrameId - lastJumpFrameId))
    let rightHeels = personState!.rightLeg!.heel.getNDetectionLocations(locationCount: min(JUMP_LOOKBACK, lastFrameId - lastJumpFrameId))
    
    if leftHeels == nil || rightHeels == nil {
      Profiler.get().profileTime(frameId: lastFrameId, tag: "Person-\(#function)-false", delta: Date().getMilliseconds() - stime)
      return 0 }
    if leftHeels!.isEmpty() || rightHeels!.isEmpty() {
      Profiler.get().profileTime(frameId: lastFrameId, tag: "Person-\(#function)-false", delta: Date().getMilliseconds() - stime)
      return 0 }
    
    lowestLeftHeel = leftHeels!.getMin(comparator: { (det1, det2) -> Bool in
      det1.getY() < det2.getY()
    })
    lowestRightHeel = rightHeels!.getMin(comparator: { (det1, det2) -> Bool in
      det1.getY() < det2.getY()
    })
    let leftHighIndex: Int = leftHeels!.get().firstIndex { (detLoc) -> Bool in
      detLoc.frameId == lowestLeftHeel!.frameId
    }!
    let rightHighIndex: Int = rightHeels!.get().firstIndex { (detLoc) -> Bool in
      detLoc.frameId == lowestRightHeel!.frameId
    }!
    
    let leftAnkles = leftHeels?.get()[0 ..< leftHighIndex]
    let rightAnkles = rightHeels?.get()[0 ..< rightHighIndex]
    if leftAnkles == nil || rightAnkles == nil {
      Profiler.get().profileTime(frameId: lastFrameId, tag: "Person-\(#function)-false", delta: Date().getMilliseconds() - stime)
      return 0 }
    if leftAnkles!.isEmpty || rightAnkles!.isEmpty {
      Profiler.get().profileTime(frameId: lastFrameId, tag: "Person-\(#function)-false", delta: Date().getMilliseconds() - stime)
      return 0 }
    highestLeftAnkle = leftAnkles!.max(by: { (det1, det2) -> Bool in
      det1.getY() < det2.getY()
    })
    highestRightAnkle = rightAnkles!.max(by: { (det1, det2) -> Bool in
      det1.getY() < det2.getY()
    })
    
    let leftHighHeels = leftHeels?.get()[leftHighIndex + 1 ..< (leftHeels?.count())!]
    let rightHighHeels = rightHeels?.get()[rightHighIndex + 1 ..< (rightHeels?.count())!]
    if leftHighHeels == nil || rightHighHeels == nil {
      return 0 }
    lowestHighLeftHeel = leftHighHeels!.max(by: { (det1, det2) -> Bool in
      det1.getY() < det2.getY()
    })
    lowestHighRightHeel = rightHighHeels!.max(by: { (det1, det2) -> Bool in
      det1.getY() < det2.getY()
    })
    
    if lowestLeftHeel == nil || lowestRightHeel == nil || lowestHighLeftHeel == nil || lowestHighRightHeel == nil {
      Profiler.get().profileTime(frameId: lastFrameId, tag: "Person-\(#function)-false", delta: Date().getMilliseconds() - stime)
      return 0
    }
    
    if jumpConditionOne() {
      if (max(lowestHighLeftHeel!.getFrameId(), lowestHighRightHeel!.getFrameId()) - lastJumpFrameId) <= MIN_JUMP_FRAME_DISTANCE {
        return lastJumpFrameId
      } else {
        return max(lowestLeftHeel!.getFrameId(), lowestRightHeel!.getFrameId())
      }
    }
    Profiler.get().profileTime(frameId: lastFrameId, tag: "Person-\(#function)-true", delta: Date().getMilliseconds() - stime)
    return lastJumpFrameId
  }
  
  public func getGroundLine() -> Double {
    let leftAnkleLocations: UtilArrayList<DetectionLocation>? = personState!.leftLeg!.ankle.getNDetectionLocations(locationCount: GROUND_LOOKBACK)
    let rightAnkleLocations: UtilArrayList<DetectionLocation>? = personState!.rightLeg!.ankle.getNDetectionLocations(locationCount: GROUND_LOOKBACK)
    if leftAnkleLocations == nil || rightAnkleLocations == nil { return groundLine }
    let highLeft: Double = leftAnkleLocations!.getMax(comparator: { (det1, det2) -> Bool in
      det1.getY() < det2.getY()
    })!.getY()
    
    let highRight: Double = rightAnkleLocations!.getMax { (det1, det2) -> Bool in
      det1.getY() < det2.getY()
    }!.getY()
    groundLine = max(highLeft, highRight)
    return groundLine
  }
  
  public func getHeadLine() -> Double {
    let stime: Double = Date().getMilliseconds()
    let leftEyeLocations: UtilArrayList<DetectionLocation>? = personState!.face!.leftEye.getNDetectionLocations(locationCount: GROUND_LOOKBACK)
    let rightEyeLocations: UtilArrayList<DetectionLocation>? = personState!.face!.rightEye.getNDetectionLocations(locationCount: GROUND_LOOKBACK)
    if leftEyeLocations == nil || rightEyeLocations == nil { return -1 }
    let highLeft: Double = leftEyeLocations!.getMin(comparator: { (det1, det2) -> Bool in
      det1.getY() < det2.getY()
    })!.getY()
    
    let highRight: Double = rightEyeLocations!.getMin { (det1, det2) -> Bool in
      det1.getY() < det2.getY()
    }!.getY()
    let headLine = max(highLeft, highRight)
    Profiler.get().profileTime(frameId: -1, tag: "Person-\(#function)-true", delta: Date().getMilliseconds() - stime)
    return headLine
  }
  
  public func inFrame() -> Bool {
    return personState!.getDetectionSubClasses().allSatisfy({$0.inFrame()})
  }
  
  func jumpConditionOne() -> Bool {
    return (lowestLeftHeel!.getY() + MIN_JUMP) < highestLeftAnkle!.getY() &&
              (lowestRightHeel!.getY() + MIN_JUMP) < highestRightAnkle!.getY() &&
              (lowestHighLeftHeel!.getY() - MIN_JUMP) > lowestLeftHeel!.getY() &&
              (lowestHighRightHeel!.getY() - MIN_JUMP) > lowestRightHeel!.getY()
  }
  
  func changeCalibrationStatus(isCalibrated: Bool){
    personState?.isCalibrated = isCalibrated
  }
  
  public override func getDebugText() -> String {
    return "PersonController"
  }
  
  internal func getBodyPart(label: Posenet.BODYPART) -> ObjectDetectionState? {
    var bodyElement: ObjectDetectionState?
    self.personState?.bodyParts.forEach({ bodyPart in
      bodyPart.bodyElements.forEach({ element in
        if element.getLabel() == label.rawValue {
          bodyElement = element
        }
      })
    })
    return bodyElement
  }
  
  public override func cleanup() {
    super.cleanup()
    self.personState?.removeObservers()
    self.personState = nil
    self.highestLeftAnkle = nil
    self.highestRightAnkle = nil
    self.lowestLeftHeel = nil
    self.lowestRightHeel = nil
    self.lowestHighLeftHeel = nil
    self.lowestHighRightHeel = nil
  }
}
