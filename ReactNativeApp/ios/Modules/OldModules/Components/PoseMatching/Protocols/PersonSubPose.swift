//
//  PersonSubPose.swift
//  jogo
//
//  Created by arham on 25/03/2021.
//

import Foundation

protocol PersonSubPose {
  func match(person: PersonDetection) -> Bool
}
