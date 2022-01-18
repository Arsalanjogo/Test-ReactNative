//
//  ExerciseStatsJsonManager.swift
//  jogo
//
//  Created by arham on 21/09/2021.
//

import Foundation

class ExerciseStatsJsonManager {
  
  private static var shared: ExerciseStatsJsonManager?
  
  private var exerciseJsonPath: URL?
  private var exerciseJsonCodable: ExerciseJsonCodable?
  
  private init() { }
  
  public static func get() -> ExerciseStatsJsonManager {
    if ExerciseStatsJsonManager.shared == nil {
      ExerciseStatsJsonManager.shared = ExerciseStatsJsonManager()
    }
    return ExerciseStatsJsonManager.shared!
  }
  
  public static func remove() {
    if ExerciseStatsJsonManager.shared != nil {
      ExerciseStatsJsonManager.shared = nil
    }
  }
  
  public func getExerciseJSON() -> ExerciseJsonCodable {
    if exerciseJsonCodable == nil {
      exerciseJsonCodable = ExerciseJsonCodable(
        score_type: "",
        json_path: "",
        video_path: "",
        final_score: 0,
        score_frame_ids: [],
        exercise_name: "",
        question_mode: "",
        high_score: 0,
        completion_time: 0,
        time_stamps: [],
        frames: [],
        person_data: [String: PointDataPacket](),
        ball_data: [String: PointDataPacket](), events: [EventsPacket]())
    }
    return exerciseJsonCodable!
  }
  
  public func resetExerciseJSON() {
    self.exerciseJsonPath = nil
    _ = self.getExerciseJsonPath()
  }
  
  public func getExerciseJsonPath() -> URL {
    if exerciseJsonPath == nil {
      let jsonName: String = "\(BaseExercise.getName())_\(Date().getMilliseconds()).json"
      exerciseJsonPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(jsonName)
    }
    return exerciseJsonPath!
  }
  
  public func setExerciseJSON(value: ExerciseJsonCodable) {
    self.exerciseJsonCodable = value
  }
  
  public func setScoreIds(value: ScoreJson) {
    self.exerciseJsonCodable?.score_frame_ids.append(value)
  }
  
  private func setFrameIds(value: Int) {
    self.exerciseJsonCodable?.frames.append(value)
  }
  
  private func setTimeStamps(value: String) {
    self.exerciseJsonCodable?.time_stamps.append(value)
  }
  
  public func setCameraInfo(frameId: Int, timeStamp: String) {
    self.setFrameIds(value: frameId)
    self.setTimeStamps(value: timeStamp)
  }
  
  public func createExerciseJsonPath() -> URL {
    let jsonName: String = "\(GameContext.getContext()?.getGame()?.rawValue ?? "NoName")_\(Date().getMilliseconds()).json"
    exerciseJsonPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(jsonName)
    return exerciseJsonPath!
  }
  
  public func fillProperties(completionTime: Double) {
    let jsonPath: URL = self.createExerciseJsonPath()
    exerciseJsonCodable?.exercise_name = BaseExercise.getName()
    exerciseJsonCodable?.json_path = jsonPath.absoluteString
    exerciseJsonCodable?.score_type = BaseExercise.baseExercise?.exerciseSettings?.getScoreType().rawValue ?? "undefined"
    exerciseJsonCodable?.question_mode = BaseExercise.baseExercise?.exerciseSettings?.getQuestionMode().rawValue ?? "undefind"
    exerciseJsonCodable?.high_score = BaseExercise.baseExercise?.exerciseSettings?.getHighScore() ?? -1
    do { exerciseJsonCodable?.final_score = try BaseExercise.baseExercise?.score?.getFinalScore() ?? -1 } catch { }
    exerciseJsonCodable?.video_path = ScreenRecorder.videoPath.absoluteString
    exerciseJsonCodable?.completion_time = completionTime
  }
  
  func convertAndWriteToFile() {
    let encoder: JSONEncoder = JSONEncoder()
    if ExerciseSettings.DEBUG_MODE {
      encoder.outputFormatting = .prettyPrinted
    }
    
    do {
      try encoder.encode(exerciseJsonCodable!).write(to: exerciseJsonPath!)
    } catch {
      Logger.shared.logError(logType: .ERROR, error: error, extraMsg: "Unable to write JSON file!")
    }
  }
  
  public func insertEvent(value: EventsPacket) {
    var jsonCodable: ExerciseJsonCodable = self.getExerciseJSON()
    jsonCodable.events?.append(value)
    self.setExerciseJSON(value: jsonCodable)
  }
  
  // MARK: ObjectDetection Information Append Logic
  
  public func insertAllDetections(values: [DetectionLocation]) {
    var jsonCodable: ExerciseJsonCodable = self.getExerciseJSON()
    for value in values {
      let fid: Int = value.frameId
      let path: String = value.label != "ball" ? "person" : "ball"

      if path == "person" {
        if jsonCodable.person_data[value.label] == nil {
          jsonCodable = self.insertFirstPersonValueIntoOutputJson(fid: fid, value: value, data: jsonCodable)
        } else {
          jsonCodable = self.insertPersonValueIntoOutputJson(fid: fid, value: value, data: jsonCodable)
        }
      } else {
        if jsonCodable.ball_data[value.label] == nil {
          jsonCodable = self.insertFirstBallValueIntoOutputJson(fid: fid, value: value, data: jsonCodable)
        } else {
          jsonCodable = self.insertBallValueIntoOutputJson(fid: fid, value: value, data: jsonCodable)
        }
      }
    }
    self.setExerciseJSON(value: jsonCodable)
  }
  
  private func insertFirstPersonValueIntoOutputJson(fid: Int, value: DetectionLocation, data: ExerciseJsonCodable) -> ExerciseJsonCodable {
    var info = PointDataPacket(x: [], y: [], status: [])
    var eData: ExerciseJsonCodable = data
    if fid != 0 {
      let endValue: Int = fid - (info.x.count)
      if endValue > 1 {
        for _ in 0..<endValue {
          info.x.append("0")
          info.y.append("0")
          info.status.append(DetectionLocation.STATUS.SKIPPED.rawValue)
        }
      }
    }
    info.x.append(value.getX().n_dp_str())
    info.y.append(value.getY().n_dp_str())
    info.status.append(value.status.rawValue)
    eData.person_data[value.label] = info
    return eData
  }
  
  private func insertPersonValueIntoOutputJson(fid: Int, value: DetectionLocation, data: ExerciseJsonCodable) -> ExerciseJsonCodable {
    var eData: ExerciseJsonCodable = data
    let difference = fid - (data.person_data[value.label]!.x.count)
    if difference > 1 {
      for _ in 0..<difference {
        eData.person_data[value.label]?.x.append("0")
        eData.person_data[value.label]?.y.append("0")
        eData.person_data[value.label]?.status.append(DetectionLocation.STATUS.SKIPPED.rawValue)
      }
    }
    eData.person_data[value.label]?.x.append(value.getX().n_dp_str())
    eData.person_data[value.label]?.y.append(value.getY().n_dp_str())
    eData.person_data[value.label]?.status.append(value.status.rawValue)
    return eData
  }
  
  private func insertFirstBallValueIntoOutputJson(fid: Int, value: DetectionLocation, data: ExerciseJsonCodable) -> ExerciseJsonCodable {
    var eData: ExerciseJsonCodable = data
    var info = PointDataPacket(x: [], y: [], status: [], width: [], height: [])
    if fid != 0 {
      let endValue: Int = fid - (info.x.count)
      if endValue > 1 {
        for _ in 0..<endValue {
          info.x.append("0")
          info.y.append("0")
          info.status.append(DetectionLocation.STATUS.SKIPPED.rawValue)

          info.width?.append(Double((value as? RectLocation)?.getRectangle().width ?? 0).n_dp_str())
          info.height?.append(Double((value as? RectLocation)?.getRectangle().width ?? 0).n_dp_str())

        }
      }
    }
    info.x.append(value.getX().n_dp_str())
    info.y.append(value.getY().n_dp_str())
    info.status.append(value.status.rawValue)
    info.width?.append(Double((value as? RectLocation)?.getRectangle().width ?? 0).n_dp_str())
    info.height?.append(Double((value as? RectLocation)?.getRectangle().width ?? 0).n_dp_str())
    eData.ball_data[value.label] = info
    return eData
  }
  
  private func insertBallValueIntoOutputJson(fid: Int, value: DetectionLocation, data: ExerciseJsonCodable) -> ExerciseJsonCodable {
    var eData: ExerciseJsonCodable = data
    let difference = fid - (data.ball_data[value.label]!.x.count)
    if difference > 1 {
      for _ in 0..<difference {
        eData.ball_data[value.label]?.x.append("0")
        eData.ball_data[value.label]?.y.append("0")
        eData.ball_data[value.label]?.status.append(DetectionLocation.STATUS.SKIPPED.rawValue)
        eData.ball_data[value.label]?.width?.append("0")
        eData.ball_data[value.label]?.height?.append("0")
      }
    }
    eData.ball_data[value.label]?.x.append(Double((value as? RectLocation)?.getRectangle().midX ?? 0).n_dp_str())
    eData.ball_data[value.label]?.y.append(Double((value as? RectLocation)?.getRectangle().midY ?? 0).n_dp_str())
    eData.ball_data[value.label]?.width?.append(Double((value as? RectLocation)?.getRectangle().width ?? 0).n_dp_str())
    eData.ball_data[value.label]?.height?.append(Double((value as? RectLocation)?.getRectangle().height ?? 0).n_dp_str())
    eData.ball_data[value.label]?.status.append(value.status.rawValue)
    return eData
  }
}
