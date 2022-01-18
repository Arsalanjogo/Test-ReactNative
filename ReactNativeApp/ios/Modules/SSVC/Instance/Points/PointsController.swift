//
//  PointsController.swift
//  jogo
//
//  Created by Mohsin on 13/10/2021.
//

import Foundation

public class PointsController: Controller {
  

  var _state: PointsState!
  var scoreSound = SoundRender(value: SoundMapping.Score.Beep.Asset)

  var incrementSound = SoundRender(value: SoundMapping.Score.Beep.Asset)
  var decrementSound = SoundRender(value: SoundMapping.Score.Beep_Two.Asset)
  
  init(state: PointsState) {
    super.init(state: state)
    self._state = state
  }
  
  public override func getDebugText() -> String {
    return ""
  }
  
  public func incrementPoints(value: Int) {
    setPointsInternal(amount: _state.currentPoints.value + value)
    setAnimationPoints(amount: value)
    _ = incrementSound.play()
    recordAction(value: value)
  }
  
  public func decrementPoints(value: Int) {
    setPointsInternal(amount: max(0,  _state.currentPoints.value - value))
    
    //controller.getKnownLastN(locationCount: 1)?.getLast()
    if value != 0 {
      if let ballLoc = GamePhase.getPhase()?.ball?.getState().getDetectedLocation() {
        showPointAnimationAtLocation(location: ballLoc, isNegative: true)
      }
    }
    
    _ = decrementSound.play()
    recordAction(value: -value)
  }
  
  public func resetPoints() {
    setPointsInternal(amount: _state.DEFAULT_POINTS)
    recordAction(value: -_state.currentPoints.value)
  }
  
  public func setPoints(amount: Int) {
    setPointsInternal(amount: amount)
    recordAction(value: amount)
  }
  
  public func getPoints() -> Int {
    return _state.currentPoints.value
  }

  public func setAnimationPoints(amount: Int) {
    _state.animationPoints = _state.animationPoints + amount
    
    // controller.getKnownLastN(locationCount: 1)?.getLast()
    if getAnimationPoints() >= _state.animationSettings {
      if let ballLoc = GamePhase.getPhase()?.ball?.getState().getDetectedLocation() {
        showPointAnimationAtLocation(location: ballLoc, isNegative: false)
      }
      resetAnimationPoints()
    }
  }
  
  public func getAnimationPoints() -> Int {
    return _state.animationPoints
  }
  
  public func resetAnimationPoints() {
    _state.animationPoints = 0
  }
  
  public func showPointAnimationAtLocation(location: DetectionLocation, isNegative: Bool = false) {
    _state.lastPoint.accept((location, isNegative))
  }
  
  private func setPointsInternal(amount: Int) {
    _state.points.append((amount, Date().getMilliseconds()))
    _state.currentPoints.accept(amount)
  }
  
  private func recordAction(value: Int) {
    let _infoBlob: InfoBlob? = try? GameContext.getContext()?.infoBlobArrayList.getLast()
    guard let infoBlob = _infoBlob else {
      return
    }
    ExerciseStatsJsonManager.get().setScoreIds(value: ScoreJson(frame_id: infoBlob.frameId ?? 0, score: value))
  }
}
