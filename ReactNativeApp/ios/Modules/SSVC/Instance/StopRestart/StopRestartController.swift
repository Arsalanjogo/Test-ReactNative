//
//  StopRestartController.swift
//  Football433
//
//  Created by Muhammad Nauman on 15/12/2021.
//

import Foundation

public class StopRestartController: Controller {
  
  init(state: StopRestartState) {
    super.init(state: state)
  }
  
  func getState() -> Phase.State {
    return (self.state as! StopRestartState).state
  }
  
}
