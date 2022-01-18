//
//  FinishController.swift
//  jogo
//
//  Created by Mohsin on 24/11/2021.
//

import Foundation

public class FinishController: Controller {
  
  init(state: FinishState) {
    super.init(state: state)
  }
  
  func isDone() -> Bool {
    return (self.state as? FinishState)?.isEnded ?? false
  }
  
}
