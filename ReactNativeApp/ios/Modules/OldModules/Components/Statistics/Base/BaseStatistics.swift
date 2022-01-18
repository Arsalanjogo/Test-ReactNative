//
//  BaseStatistics.swift
//  jogo
//
//  Created by arham on 10/03/2021.
//

import Foundation

class BaseStatistics: CleanupProtocol {
  // Stores objects required for basic calculations. Inherited by all statistics object.
  internal var score: BaseScore?
  internal var infoBlobArrayList: UtilArrayList<InfoBlob> = UtilArrayList<InfoBlob>()
  
  init(score: BaseScore, infoBlobArrayList: UtilArrayList<InfoBlob>) {
    self.score = score
    self.infoBlobArrayList = infoBlobArrayList
  }
  
  public func writeStatsToJSON() {
    // Override this function.
  }
  
  public func cleanup() {
    
  }
  
}
