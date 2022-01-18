//
//  Mediator.swift
//  NATIVE_AI
//
//  Created by Mac Book on 09/07/2020.
//

import Foundation

// Used to link the app with the Objective-C code.
@objc(iOSNativeApp)
class IOSNativeApp: RCTEventEmitter {
  
  public static var shared: IOSNativeApp?

  override init() {
      super.init()
      IOSNativeApp.shared = self
  }
  
  @objc(sendEventToReactNative:)
  func sendEventToReactNative(_ body: [String: AnyObject]) {
    self.sendEvent(withName: "gameCompleted", body: body)
  }
  
  override func supportedEvents() -> [String]! {
    return ["gameCompleted"]
  }
}
