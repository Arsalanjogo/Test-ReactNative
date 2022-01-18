//
//  IOStream.swift
//  jogo
//
//  Created by arham on 22/02/2021.
//

import Foundation

// Called by the exercise lead model when an image has been processed.
// To start the flow for the processExercise.
protocol IOStream {
  func onImageProcessed(infoBlob: InfoBlob)

}
