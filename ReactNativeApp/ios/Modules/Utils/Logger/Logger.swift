//
//  Logger.swift
//  jogo
//
//  Created by Muhammad Nauman on 02/03/2021.
//

import Foundation
import SwiftLog

// TODO: Create a file with the all the logs written into it via this module.
// Send only that file in the case of completion/crash/closing/restarting to the Sentry Server.

class Logger {
  // Allows logging from everywhere.
  static let shared = Logger()
  
  private var timeMap: [String: Double] = [String: Double]()
  private var logNSecondsMap: [String: Double] = [String: Double]()
  private var fpsMap: [String: Int] = [String: Int]()
  private let loggerQueue: DispatchQueue = DispatchQueue(label: "Logging",
                                                         qos: .default,
                                                         attributes: [],
                                                         autoreleaseFrequency: .inherit,
                                                         target: .none)
  private var runId: String = ""

  private init() {
    let date = Date()
    let format = DateFormatter()
    format.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let timestamp = format.string(from: date)
    Log.logger.name = timestamp
    //FIXME: Remove or comment this ↓
//    SentrySDK.crash()
  }
  
  func setRunId() {
    runId = UUID().uuidString
  }
  
  func log(logType: LogType, message: String, file: String = #file, function: String = #function) {
    if ExerciseSettings.DEBUG_MODE {
      logw("\(logType.rawValue): \(message)")
    }
  }
  
  func logTime(time: Double?, msg: String) -> Double {
    self.loggerQueue.sync(flags: .barrier) {
      if timeMap[msg] == nil {
        if time != nil {
          timeMap[msg] = time!
          return time!
        }
        return 0
      }
      if time != nil {
        let diff: Double = time! - timeMap[msg]!
        self.log(logType: .DEBUG, message: "\(1000 / diff) fps or \(diff) ms")
        timeMap[msg] = time!
        return time!
      }
      return 0
    }
  }
  
  func logTimeDiff(logType: LogType = .INFO, msg: String, timeDiff: Double) {
//    SentrySDK.capture(message: "\(self.runId): \(logType.rawValue): \(msg) : \(timeDiff/1000)")
  }
  
  func logError(logType: LogType = .ERROR, error: Error, extraMsg: String = "") {
//    SentrySDK.capture(message: "\(self.runId): \(logType.rawValue): \(extraMsg): \(error.localizedDescription)")
  }
  
  func logError(logType: LogType = .ERROR, text: String) {
//    SentrySDK.capture(message: "\(self.runId): \(logType.rawValue): \(text)")
  }
  
  func logFPSEveryNSeconds(seconds: Double = 9, msg: String, value: Int = 1) {
    self.loggerQueue.sync(flags: .barrier) {
      if logNSecondsMap[msg] == nil {
        logNSecondsMap[msg] = Date().timeIntervalSince1970 * 1000
        fpsMap[msg] = value
        return
      }
      let time: Double? = logNSecondsMap[msg]
      fpsMap[msg] = fpsMap[msg]! + value
      if time != nil {
        let diff: Double = Date().timeIntervalSince1970 * 1000 - time!
        if (seconds * 1000) < diff {
          let fps: Double = Double(fpsMap[msg]!) / (diff / 1000)
//          SentrySDK.capture(message: "\(self.runId): \(msg) :: \(fpsMap[msg]!) frames in \(diff/1000) = \(fps) ")
          self.logThreadMessage(logType: .DEBUG, msg: "\(msg) :: \(fpsMap[msg]!) frames in \(diff / 1000) = \(fps) ")
          logNSecondsMap[msg] = Date().timeIntervalSince1970 * 1000
          fpsMap[msg] = 0
        }
      }
      return
    }
  }
  
  func logThreadMessage(logType: LogType = .DEBUG, msg: String) {
    self.log(logType: logType, message: "\(Thread.current), \(msg)")
  }
  
  func clearMaps() {
    self.timeMap.removeAll()
    self.logNSecondsMap.removeAll()
    self.fpsMap.removeAll()
  }
  
}

enum LogType: String {
  case INFO
  case DEBUG
  case ERROR
  case WARN
}
