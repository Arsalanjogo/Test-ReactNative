//
//  JugglingState.swift
//  jogo
//
//  Created by arham on 18/11/2021.
//

import Foundation

class JugglingState: BaseGameState {
  
  internal static let BALLINVISIONRANGE: Int = 30
  internal final let KNEELINEADJUSTMENT: Double = 0.35
  
  internal final let BALLONGROUNDCOUNTER: Int = 5
  internal final let GROUNDLINETOUCHEDCOOLDOWN: Int = 5
  internal final let BALLCOOLDOWN: Int = 1
  internal final let FOOTDETECTRANGE: Int = 15
  internal final let BODYPARTRANGE: Int = 5
  
  internal var determineBounceRange: Int?
  internal var lastBounceId: Int = 0
  internal var determineBounceStartId: Int = 0
  
  internal var bounce: Bool = false
  internal var bounceDetectedLocation: DetectionLocation?
  internal var juggleLocation: DetectionLocation?
  
  internal var groundLine: Double?
  internal var kneeLine: Double?
  
  internal var leftKneeLoc: Double?
  internal var rightKneeLoc: Double?
  internal var leftHipLoc: Double?
  internal var rightHipLoc: Double?
  
  internal var rightAnkleY: Double?
  internal var leftAnkleY: Double?

  internal var ballLocations: [DetectionLocation]?
  internal var isJuggling: Bool = false
}
