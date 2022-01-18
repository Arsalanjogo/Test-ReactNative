//
//  BaseGameController.swift
//  jogo
//
//  Created by arham on 18/11/2021.
//

import Foundation

class BaseGameController: Controller {
  
  weak var pointController: PointsController?
  
  init(state: State, pointController: PointsController?) {
    self.pointController = pointController
    super.init(state: state)
  }
  
  override init(state: State) {
    super.init(state: state)
  }
  
  func process(infoBlob: InfoBlob) { }
  
}
