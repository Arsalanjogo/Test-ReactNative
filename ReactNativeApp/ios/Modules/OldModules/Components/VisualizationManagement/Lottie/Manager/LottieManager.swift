//
//  LottieManager.swift
//  jogo
//
//  Created by arham on 07/09/2021.
//

import Foundation

class LottieManager {
  typealias NoArgMethod = () -> Void
  public static var shared: LottieManager? = LottieManager()
  private let lottieQueue: DispatchQueue = DispatchQueue(label: "LottieManager", qos: .default, attributes: [], autoreleaseFrequency: .inherit, target: .none)
  private var lottieMap: NSMapTable<NSString, AnyObject> = NSMapTable<NSString, AnyObject>(keyOptions: .strongMemory, valueOptions: .weakMemory)
  
  private init() { }
  
  public static func get() -> LottieManager {
    if LottieManager.shared == nil {
      LottieManager.shared = LottieManager()
    }
    return LottieManager.shared!
  }
  
  public func insert(animation: AnyObject, animationName: String) {
    self.stop(animationName: animationName)
    lottieQueue.sync(flags: .barrier) { [weak self] in
      self?.lottieMap.setObject(animation, forKey: animationName as NSString)
      Logger.shared.log(logType: .INFO, message: "Lottie Manager count: \(animationName): \(self?.lottieMap.count ?? -1)")
    }
  }
  
  public func stop(animationName: String) {
    lottieQueue.sync(flags: .barrier) { [weak self] in
      let value: AnyObject? = self?.lottieMap.object(forKey: animationName as NSString)
      if value == nil {
        return
      }
      DispatchQueue.main.async {
        (value as? LottieBase<AnyObject>)?.stop()
      }
      self?.lottieMap.removeObject(forKey: animationName as NSString)
    }
  }
  
  public func stopAll(method: @escaping NoArgMethod) {
    lottieQueue.sync(flags: .barrier) { [unowned self] in
      let e = self.lottieMap.objectEnumerator()
      if e == nil { return }
      DispatchQueue.main.async {
        for value in e! {
          (value as! LottieProtocol).stop()
        }
        method()
      }
    }
  }
  
  public func play(animName: String) {
    lottieQueue.sync(flags: .barrier) { [unowned self] in
      let val = self.lottieMap.value(forKey: animName)
      if val == nil { return }
      DispatchQueue.main.async {
        do {
          try (val as! LottieProtocol).play()
        } catch {
          
        }
      }
    }
  }
  
}
