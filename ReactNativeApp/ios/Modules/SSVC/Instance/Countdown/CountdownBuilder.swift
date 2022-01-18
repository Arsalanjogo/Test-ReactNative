//
//  CountdownBuilder.swift
//  jogo
//
//  Created by Mohsin on 12/11/2021.
//

import Foundation

public class CountdownBuilder: SSVCBuilder {
  
  public static func build() -> SSVC<CountdownState, CountdownView, CountdownController> {
    let state = CountdownState()
    let view = CountdownView(state: state)
    let controller = CountdownController(state: state)
    return SSVC(state: state, stateView: view, controller: controller)
  }
  
}
