//
//  CountdownController.swift
//  jogo
//
//  Created by Mohsin on 12/11/2021.
//

import Foundation

public class CountdownController: Controller {
  
  init(state: CountdownState) {
    super.init(state: state)
  }
  
  func isDone() -> Bool {
    return (self.state as? CountdownState)?.isCountdownEnded ?? false
  }
  
}
