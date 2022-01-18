//
//  InferLocation.swift
//  jogo
//
//  Created by arham on 05/03/2021.
//

import Foundation

class InferLocation {
  // Acts as an abstract class for the InferLocation child classes.
  // 1 to many  with normal array and util array
  public func infer(before: [DetectionLocation], known: DetectionLocation) {}
  public func infer(before: UtilArrayList<DetectionLocation>, known: DetectionLocation) {}
}
