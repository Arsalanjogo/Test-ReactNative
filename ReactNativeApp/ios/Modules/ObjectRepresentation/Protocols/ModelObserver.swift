//
//  ModelObserver.swift
//  jogo
//
//  Created by arham on 22/02/2021.
//

import Foundation

// This is used as a comparator and gives all observers functionality.
// id is specifically used as the comparator when unsetting the observers.
protocol ModelObserver {
  var id: Int { get set }
  func parse(detectedLocations: [DetectionLocation], infoBlob: InfoBlob)
  func setModel(model: ObservableModel)
  func getModelType() -> ModelManager.MODELTYPE
}
