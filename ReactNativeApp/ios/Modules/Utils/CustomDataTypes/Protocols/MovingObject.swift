//
//  MovingObject.swift
//  jogo
//
//  Created by arham on 04/08/2021.
//

import Foundation

internal protocol MovingObject {
  func getLocation() -> DetectionLocation?
  func getLabel() -> String
}
