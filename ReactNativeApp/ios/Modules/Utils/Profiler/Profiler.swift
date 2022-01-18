//
//  Profiler.swift
//  jogo
//
//  Created by arham on 08/09/2021.
//

import Foundation
import CoreData


class Profiler {
  
  // MARK: Profiler Core Components
  private static var shared: Profiler?
  public var profileCodable: ProfileCodable?
  private static let profilerQueue: DispatchQueue = DispatchQueue(label: "Profiling", qos: .default, attributes: [], autoreleaseFrequency: .inherit, target: .none)
  private var maps: [String: Int]?
  private var every: Int = 15
  // MARK: Lifecycle
  private init() { }
  
  // MARK: Get. No Set!!
  public static func get() -> Profiler {
    if Profiler.shared == nil {
      Profiler.shared = Profiler()
    }
    return Profiler.shared!
  }
  
  public func remove() {
    if Profiler.shared != nil {
      Profiler.shared!.profileCodable = nil
      Profiler.shared!.maps = nil
      Profiler.shared = nil
    }
  }
  
  private func setProfile() {
    if self.profileCodable == nil {
      self.profileCodable = ProfileCodable(
        timeProfile: [Tag: FrameProfileCodable](),
        tempProfile: BasicProfileInfoCodable(info: [Int: String]()),
        memProfile: BasicProfileInfoCodable(total: 0, info: [Int: String]()))
      self.maps = [String: Int]()
      self.profileCodable!.memProfile.total = MemoryProfiler.getTotal()
    }
  }
  
  private func intermediate(val: String, frameId: Int) -> Bool {
    self.setProfile()
    if ((self.maps?.keys.contains(val)) != nil) {
    } else {
      self.maps?[val] = frameId
      return false
    }
    if frameId - (self.maps?[val] ?? 0) < self.every { return false }
    self.maps![val] = frameId
    return true
  }
  
  public func profileTemp(frameId: Int) {
    let val = "temp"
    
    Profiler.profilerQueue.sync(flags: .barrier) {
      if !self.intermediate(val: val, frameId: frameId) {
        return
      }
      var temp = self.profileCodable!
      temp.tempProfile.info[frameId] = ThermalProfiler.get()
      self.profileCodable = temp
    }
    
  }
  
  public func profileMemory(frameId: Int) {
    let val = "mem"
    
    Profiler.profilerQueue.sync(flags: .barrier) {
      if !self.intermediate(val: val, frameId: frameId) {
        return
      }
      var temp = self.profileCodable!
      temp.memProfile.info[frameId] = MemoryProfiler.get()
      self.profileCodable = temp
    }
    
  }
  
  public func profileTime(frameId: Int, tag: String, delta: Double) {
    self.setProfile()
    Profiler.profilerQueue.sync(flags: .barrier) {
      if !self.intermediate(val: tag, frameId: frameId) {
        return
      }
      var temp = self.profileCodable!
      if temp.timeProfile.keys.contains(tag) {
        temp.timeProfile[tag]!.info[frameId] = FrameProfileInfoCodable(
          delta: delta.n_dp(dp: 2))
      } else {
        temp.timeProfile[tag] = FrameProfileCodable(info: [Int: FrameProfileInfoCodable]())
        temp.timeProfile[tag]!.info[frameId] = FrameProfileInfoCodable(
          delta: delta.n_dp(dp: 2))
      }
      self.profileCodable = temp
    }
  }
  
  public func saveProfile() {
    let jsonName: String = "profile_\(Date().getMilliseconds()).json"
    let profilePath: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(jsonName)
    self.convertAndWriteToFile(url: profilePath)
    self.remove()
  }
  
  func convertAndWriteToFile(url: URL) {
    let encoder: JSONEncoder = JSONEncoder()
    if ExerciseSettings.DEBUG_MODE {
      encoder.outputFormatting = .prettyPrinted
    }
    
    do {
      try encoder.encode(self.profileCodable).write(to: url)
    } catch {
      Logger.shared.logError(logType: .ERROR, error: error, extraMsg: "Unable to write Profile JSON file!")
    }
  }
}
