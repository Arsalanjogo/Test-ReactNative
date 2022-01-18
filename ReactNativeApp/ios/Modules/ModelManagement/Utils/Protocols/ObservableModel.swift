//
//  ObservableModel.swift
//  jogo
//
//  Created by arham on 22/02/2021.
//

import Foundation

// Generic interface used for the all models.
// Add/Remove observers from the model.
// Send data to observers via notifying.
protocol ObservableModel {
  func addObservers(observers: [ModelObserver])
  func removeObservers(observers: [ModelObserver])
  func addObserver(observer: ModelObserver)
  func removeObserver(observer: ModelObserver)
  func notifyListeners(locations: [DetectionLocation], infoBlob: InfoBlob)
  func loadModel()
  func supplyFrame(sampleBuffer: ExtendedSampleBuffer)
  
}
