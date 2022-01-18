//
//  PromoBuilder.swift
//  jogo
//
//  Created by Muhammad Nauman on 08/11/2021.
//

import Foundation

public class PromoBuilder: SSVCBuilder {
  
  public static func build() -> SSVC<PromoState, PromoView, PromoController> {
    let state = PromoState()
    let view = PromoView(state: state)
    let controller = PromoController(state: state)
    return SSVC(state: state, stateView: view, controller: controller)
  }
  
}
