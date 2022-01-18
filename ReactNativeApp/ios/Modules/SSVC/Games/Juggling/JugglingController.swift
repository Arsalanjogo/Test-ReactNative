//
//  JugglingController.swift
//  jogo
//
//  Created by arham on 18/11/2021.
//

import Foundation

class JugglingController: BaseGameController {
  weak var ballController: BallController?
  weak var personController: PersonController?
  
  init(state: JugglingState,
       ballController: BallController?,
       personController: PersonController?,
       pointController: PointsController?) {
    self.ballController = ballController
    self.personController = personController
    super.init(state: state, pointController: pointController)
  }
  
  func getState() -> JugglingState? {
    return self.state as? JugglingState
  }
  
  override func process(infoBlob: InfoBlob) {
    guard let _state = self.getState() else { return }
    if infoBlob.frameId! <= _state.lastBounceId { return }
    guard let _person = self.personController else { return }

    self.calculateProperties(_person: _person, _state: _state)
    
    do {
      let val: Int = infoBlob.frameId! - max(_state.determineBounceStartId, _state.lastBounceId)
      _state.determineBounceRange = max(val, 0)
    } catch {
      Logger.shared.log(logType: .WARN,
                        message: "Could not extract last value from infoBlob while trying to get determineBounceRange")
      return
    }
    
    if _state.determineBounceRange! <= _state.BALLCOOLDOWN { return }
    
    if isGroundTouched() { groundLineTouched() }
    
    processRandomFoot(state: _state)
  }
  
  public func leftFootUp(state: JugglingState) -> Bool {
    return state.rightAnkleY ?? 0 > state.leftAnkleY ?? 1
  }
  
  public func rightFootUp(state: JugglingState) -> Bool {
    return state.leftAnkleY ?? 0 > state.rightAnkleY ?? 1
  }
  
  private func processCase(state: JugglingState) {
    if determineJuggle(state: state) { validJuggle(state: state) }
  }
  
  public func processLeftFoot(state: JugglingState) {
    if leftFootUp(state: state) && determineJuggle(state: state) { validJuggle(state: state) }
  }

  public func processRightFoot(state: JugglingState) {
    if rightFootUp(state: state) && determineJuggle(state: state) { validJuggle(state: state) }
  }
  
  public func processRandomFoot(state: JugglingState) {
    if determineJuggle(state: state) { validJuggle(state: state) }
  }
  
  fileprivate func determineJuggle(state: JugglingState) -> Bool {
    state.bounce = false
    
    let bounceCondition: Bool = didFootTouchBall(state: state)
    let newBounceId: Int = self.ballController!.didBounce(
      orientation: .ANY,
      frameId: state.determineBounceStartId,
      axis: .y)
    if newBounceId == -1 {
      return state.bounce
    }
    
    if newBounceId > state.lastBounceId && bounceCondition {
      state.lastBounceId = newBounceId
      state.determineBounceStartId = state.lastBounceId + state.BALLCOOLDOWN
      state.bounce = true
    }
    Logger.shared.log(logType: .INFO, message: "Bounce: \(state.bounce) @ \(newBounceId)")
    return state.bounce
  }
  
  fileprivate func hasBeenBelowTheKnee(state: JugglingState) -> Bool {
    let ballLocations: UtilArrayList<DetectionLocation>? = ballController?.getKnownLastN(locationCount: state.determineBounceRange!)
    if ballLocations == nil { return false }
    var result: Bool = true
    ballLocations!.get().forEach { (detLoc) in
      result = result && detLoc.getY() >= state.kneeLine!
    }
    if !result {
      do {
        guard let _context = GameContext.getContext() else { return false }
        state.lastBounceId = try _context.infoBlobArrayList.getLast()!.frameId!
      } catch {}
    }
    return result
  }
  
  fileprivate func hasBeenAboveTheKnee(state: JugglingState) -> Bool {
    let ballLocations: UtilArrayList<DetectionLocation>? = ballController?.getKnownLastN(locationCount: state.determineBounceRange!)
    if ballLocations == nil { return false }
    if ballLocations!.count() == 0 { return false }
    let locs: [DetectionLocation] = ballLocations!.get()
    var aboveKneeCount: Int = 0
    var result: Bool = false
    
    for loc in locs {
      if loc.getY() > state.kneeLine! { aboveKneeCount = 0 } else {
        aboveKneeCount += 1
        if aboveKneeCount >= 3 {
          result = true
          break
        }
      }
    }
    return result
  }
  
  fileprivate func didFootTouchBall(state: JugglingState) -> Bool {
    let ballLocations: UtilArrayList<DetectionLocation>? = ballController?.getKnownLastN(locationCount: state.FOOTDETECTRANGE)
    if ballLocations == nil { return false }
    if ballLocations?.count() == 0 { return false }
    let locs: [DetectionLocation] = ballLocations!.get()
    var result: Bool = false
    
    let threshold: Double = min(state.leftKneeLoc ?? 1.0, state.rightKneeLoc ?? 1.0)
    for loc in locs {
      if loc.getY() >= threshold {
        result = true
        break
      }
    }
    return result
  }

  fileprivate func validJuggle(state: JugglingState) {
    do {
      guard let _context = GameContext.getContext() else { return }
      let currentBounceId: Int = try _context.infoBlobArrayList.getLast()!.frameId!
      state.lastBounceId = currentBounceId
      self.pointController?.incrementPoints(value: 1)
      // Point increment animation at ball location
      if let ballLoc = try ballController?.getKnownLastN(locationCount: 1)?.getLast() {
        pointController?.showPointAnimationAtLocation(location: ballLoc)
      }
      
 
      if !state.isJuggling {
        state.isJuggling = true
      }
      ExerciseStatsJsonManager.get().insertEvent(value: EventsPacket(name: "juggle",
                                                                      frame_id: currentBounceId,
                                                                      lookback: self.ballController?.getBallBounceRange() ?? 0,
                                                                      forsee: self.ballController?.getBallBounceRange() ?? 0,
                                                                     object_names: [BallState.LABEL,
                                                                                    Posenet.BODYPART.LEFT_ANKLE.rawValue,
                                                                                    Posenet.BODYPART.RIGHT_ANKLE.rawValue]))

    } catch {
      Logger.shared.log(logType: .ERROR, message: "Errored while getting last value in infoBlob array.")
    }
  }
  
  private func calculateProperties(_person: PersonController, _state: JugglingState) {
    let _leftAnkleY = _person.getBodyPart(label: .LEFT_ANKLE)?.getDetectedLocation()?.getY()
    if _leftAnkleY != nil { _state.leftAnkleY = _leftAnkleY }
    
    let _rightAnkleY = _person.getBodyPart(label: .RIGHT_ANKLE)?.getDetectedLocation()?.getY()
    if _rightAnkleY != nil { _state.rightAnkleY = _rightAnkleY }
    
    _state.groundLine = _person.getGroundLine()
    
    _state.leftKneeLoc = self.getLocFromLocation(part: _person.getBodyPart(label: .LEFT_KNEE))
    _state.rightKneeLoc = self.getLocFromLocation(part: _person.getBodyPart(label: .RIGHT_KNEE))
    
    _state.leftHipLoc = self.getLocFromLocation(part: _person.getBodyPart(label: .LEFT_HIP))
    _state.rightHipLoc = self.getLocFromLocation(part: _person.getBodyPart(label: .RIGHT_HIP))
    
    let lkl: Double = ((_state.leftKneeLoc ?? 0) * _state.KNEELINEADJUSTMENT) + ((_state.leftHipLoc ?? 0) * (1 - _state.KNEELINEADJUSTMENT))
    let rkl: Double = ((_state.rightKneeLoc ?? 0) * _state.KNEELINEADJUSTMENT) + ((_state.rightHipLoc ?? 0) * (1 - _state.KNEELINEADJUSTMENT))
    _state.kneeLine = min(lkl, rkl)
  }
  
  fileprivate func isGroundTouched() -> Bool {
    guard let _ball = self.ballController else { return false }
    guard let _state = self.getState() else { return false }
    let ballLocations: UtilArrayList<DetectionLocation>? = _ball.getNDetectionLocations(locationCount: _state.BALLONGROUNDCOUNTER)
    if ballLocations == nil { return false }
    if ballLocations!.count() == 0 { return false }
    let ballLocs: [DetectionLocation] = ballLocations!.get()
    var groundTouched: Bool = false
    
    guard let ballHeight = _ball.getHeight() else { return groundTouched }
    let ballSize: Double = (ballHeight / 2)
    let touchCounts: Int = 2
    var touches: Int = 0
    for ballLoc in ballLocs {
      if ballLoc.getY() + ballSize > _state.groundLine! {
        touches += 1
        if touches >= touchCounts {
          groundTouched = true
          break
        }
      }
    }
    return groundTouched
  }
  
  fileprivate func groundLineTouched() {
    guard let _state = self.getState() else { return }
    guard let _context = GameContext.getContext() else { return }
    do {
      let currentFrameId: Int = try _context.infoBlobArrayList.getLast()!.frameId!
      // TODO: Do the score thingy
      if _state.isJuggling {
        pointController?.decrementPoints(value: 5)
        _state.isJuggling = false
        ExerciseStatsJsonManager.get().insertEvent(value: EventsPacket(name: "groundTouched",
                                                                       frame_id: currentFrameId,
                                                                       lookback: 5,
                                                                       forsee: 5,
                                                                       object_names: [BallState.LABEL, Posenet.BODYPART.RIGHT_ANKLE.rawValue, Posenet.BODYPART.LEFT_ANKLE.rawValue]))
      }
//      if score!.getCount() > 0 { score?.resetCount(blink: false, beep: false) }
      
      _state.determineBounceStartId = currentFrameId + _state.GROUNDLINETOUCHEDCOOLDOWN
    } catch {
      Logger.shared.log(logType: .ERROR, message: "Could not get the last value from the infoBlob array.")
    }
  }
  
  func getLocFromLocation(part: ObjectDetectionState?) -> Double? {
    guard let _state = self.getState() else { return nil }
    guard let _part = part else { return nil }
    let location: UtilArrayList<DetectionLocation>? = _part.getNDetectionLocations(locationCount: _state.BODYPARTRANGE)
    if location == nil { return nil }
    let partVal: Double = location!.getMin(comparator: { (first, second) -> Bool in
      first.getY() < second.getY()
    })!.getY()
    return partVal
  }
}
