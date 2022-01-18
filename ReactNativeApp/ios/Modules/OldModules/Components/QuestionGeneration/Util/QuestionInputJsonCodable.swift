//
//  QuestionInputJsonCodable.swift
//  jogo
//
//  Created by arham on 24/06/2021.
//

import Foundation


struct ExerciseJsonRepresentation: Codable {
  var questions: [QuestionJsonRepresentation]
}

struct QuestionJsonRepresentation: Codable {
  var question: String
  var answer: String
  var A: String
  var B: String
  var C: String
}
