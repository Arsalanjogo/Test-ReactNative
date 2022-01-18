//
//  LottieProtocol.swift
//  jogo
//
//  Created by Admin on 19/05/2021.
//

import Foundation

protocol LottieProtocol {
  func runningCheck() throws
  func stop()
  func play() throws
  func tag() -> String
}
