//
//  BoneController.swift
//  jogo
//
//  Created by Mohsin on 18/10/2021.
//

import Foundation

public class BoneController: Controller {
  
  var boneState: BoneState?
  
  init(state: BoneState) {
    super.init(state: state)
    self.boneState = state
  }
  
  public override func getDebugText() -> String {
    return ""
  }
  
}
