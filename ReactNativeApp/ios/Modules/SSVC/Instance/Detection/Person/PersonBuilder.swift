//
//  PersonBuilder.swift
//  jogo
//
//  Created by Mohsin on 18/10/2021.
//

import Foundation

internal class PersonBuilder: SSVCBuilder {
  
  internal static func buildState(modelType: ModelManager.MODELTYPE, exerciseLead: Bool) -> PersonState {
    return PersonState(modelType: ModelManager.MODELTYPE.POSENET, exerciseLead: false, observerId: Posenet.ObserverID.PERSON.rawValue)
  }
  
  internal static func build(state: PersonState) -> PersonSSVC<PersonState, PersonView, PersonController> {
    let view = PersonRectView(state: state)
    let controller = PersonController(state: state)
    return PersonSSVC(state: state, stateView: view, controller: controller)
  }
  
  internal static func build(modelType: ModelManager.MODELTYPE,
                                          exerciseLead: Bool) -> PersonSSVC<PersonState, PersonView, PersonController> {
    let state = buildState(modelType: modelType, exerciseLead: exerciseLead)
    let view = PersonRectView(state: state)
    let controller = PersonController(state: state)
    return PersonSSVC(state: state, stateView: view, controller: controller)
  }
}
