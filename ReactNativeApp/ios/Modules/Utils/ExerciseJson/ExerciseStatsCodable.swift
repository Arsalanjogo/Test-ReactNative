//
//  Codables.swift
//  jogo
//
//  Created by arham on 06/05/2021.
//

import Foundation

struct OldExerciseCompleteHelperScore: Codable {
  var final_score: String
  var question_score: String
}

struct ExerciseCompleteHelperScore: Codable {
  var final_score: String
}

struct ExerciseCompleteHelperQuestions: Codable {
  var final_score: String
  var question_score: String
}

struct AnswerJson: Codable {
  var answer: String
  var selected: Bool
  var answerTime: Double
}

struct QuestionJson: Codable {
  var question: String
  var resolved: Bool
  var answered: Bool
  var correct: Bool
  var answers: [AnswerJson]
}

struct ExerciseCompleteHelper: Codable {
  var videoPath: String
  var score: ExerciseCompleteHelperScore?
  var json_path: String
  var exercise_name: String
  var completion_time: String
  var questions: ExerciseCompleteHelperQuestions?
}

struct OldExerciseCompleteHelper: Codable {
  var videoPath: String
  var score: OldExerciseCompleteHelperScore?
  var json_path: String
  var exercise_name: String
  var completion_time: String
  var questions: ExerciseCompleteHelperQuestions?
}

// ---------------------------------------------------------

struct ScoreJson: Codable {
  var frame_id: Int
  var score: Int
}

struct PointDataPacket: Codable {
  var x: [String]
  var y: [String]
  var status: [String]
  var width: [String]?
  var height: [String]?
}

struct EventsPacket: Codable {
  var name: String
  var frame_id: Int
  var lookback: Int
  var forsee: Int
  var object_names: [String]
}

struct ExerciseJsonCodable: Codable {
  var score_type: String
  var json_path: String
  var video_path: String
  var final_score: Int
  var score_frame_ids: [ScoreJson]
  var exercise_name: String
  var question_mode: String?
  var high_score: Int?
  var completion_time: Double
  var time_stamps: [String]
  var frames: [Int]
  var person_data: [String: PointDataPacket]
  var ball_data: [String: PointDataPacket]
  var events: [EventsPacket]?
}
