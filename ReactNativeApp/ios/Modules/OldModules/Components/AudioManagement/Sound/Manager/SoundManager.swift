//
//  SoundManager.swift
//  jogo
//
//  Created by arham on 21/09/2021.
//

import Foundation

class SoundManager {
  typealias NoArgMethod = () -> Void
  private static var shared: SoundManager? = SoundManager()
  private let soundQueue: DispatchQueue = DispatchQueue(label: "SoundManager", qos: .default, attributes: [], autoreleaseFrequency: .inherit, target: .none)
  private var soundMap: NSMapTable<NSString, AnyObject> = NSMapTable<NSString, AnyObject>(keyOptions: .strongMemory, valueOptions: .weakMemory)
  
  init() { }
  
  public static func get() -> SoundManager {
    if SoundManager.shared == nil {
      SoundManager.shared = SoundManager()
    }
    return SoundManager.shared!
  }
  
  public static func remove() {
    if SoundManager.shared != nil {
      SoundManager.shared?.soundMap.removeAllObjects()
      SoundManager.shared = nil
    }
  }
  
  public func insert(sound: AnyObject, soundName: SoundMapping.SoundDef) {
    self.stop(soundName: soundName)
    soundQueue.sync(flags: .barrier) { [weak self] in
      self?.soundMap.setObject(sound, forKey: soundName.filename as NSString)
      Logger.shared.log(logType: .INFO, message: "Sound Manager count: \(soundName.filename): \(self?.soundMap.count ?? -1)")
    }
  }
  
  public func stop(soundName: SoundMapping.SoundDef) {
    soundQueue.sync(flags: .barrier) { [weak self] in
      let value: AnyObject? = self?.soundMap.object(forKey: soundName.filename as NSString)
      if value == nil { return }
      DispatchQueue.main.async {
        _ = (value as? SoundRender)?.stop()
      }
      self?.soundMap.removeObject(forKey: soundName.filename as NSString)
    }
  }
  
  public func stopAll(method: @escaping NoArgMethod) {
    soundQueue.sync(flags: .barrier) { [unowned self] in
      let e = self.soundMap.objectEnumerator()
      if e == nil { return }
      DispatchQueue.main.async {
        for value in e! {
          _ = (value as! SoundRender).stop()
        }
        method()
      }
    }
  }
  
  public func play(soundName: SoundMapping.SoundDef) {
    soundQueue.sync(flags: .barrier) { [unowned self] in
      let val = self.soundMap.value(forKey: soundName.filename)
      if val == nil { return }
      DispatchQueue.main.async {
        _ = (val as? SoundRender)?.play() 
      }
    }
  }
}
