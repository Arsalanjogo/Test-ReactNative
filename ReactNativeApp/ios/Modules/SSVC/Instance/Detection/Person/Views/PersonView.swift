//
//  PersonView.swift
//  jogo
//
//  Created by Mohsin on 18/10/2021.
//

import Foundation
import UIKit

public class PersonView: DynamicSV {
  
  init(state: PersonState) {
    super.init(state: state, frame: RenderLoop.getFrame()!)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
}
