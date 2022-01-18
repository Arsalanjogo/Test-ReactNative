//
//  Environment.swift
//  jogo
//
//  Created by Mohsin on 15/09/2021.
//

import Foundation


enum Environment: String {
  
  /*
   JOGO AI -> iOS Team build
   ——————
   Excercise_Debug || Debug -> Direct Run
   Excercise_Release -> Testflight

   
   JOGO Dev  -> React Native feature build
   ———————
   Dev_Debug -> Direct Run
   Dev_Release -> Testflight
   
   
   JOGO Staging -> React Native Full UI build
   ————————
   Staging_Debug -> Direct Run
   Staging_Release -> Testflight

   
   JOGO -> React Native Production
   ————————
   Release -> AppStore (LIVE)
   */
  
  
  //Native
  case debug = "Debug"
  case debugExercise = "Excercise_Debug"
  case releaseExercise = "Excercise_Release"
  
  //React Native
  case debugDevelopment = "Dev_Debug"
  case releaseDevelopment = "Dev_Release"
  case debugStaging = "Staging_Debug"
  case releaseStaging = "Staging_Release"
  case release = "Release"
  
  
  var sentry: String {
    switch self {
    case .debug, .debugExercise, .debugDevelopment, .debugStaging:
      return "development"
    case .releaseExercise, .releaseDevelopment, .releaseStaging:
      return "staging"
    default:
      return "production"
    }
  }
  
  var isDebug: Bool {
    switch self {
    case .debug, .debugExercise, .debugDevelopment, .debugStaging:
      return true
    default:
      return false
    }
  }
}


final class BuildConfiguration: NSObject {

  @objc static let shared = BuildConfiguration()

  @objc var sentryEnvironment: String
  @objc var isDebug: Bool

  private override init() {
    let currentConfiguration = Bundle.main.object(forInfoDictionaryKey: "Environment") as! String
    sentryEnvironment = Environment(rawValue: currentConfiguration)?.sentry ?? "production"
    isDebug = Environment(rawValue: currentConfiguration)?.isDebug ?? true
    print("-Environment -sentry :", sentryEnvironment)
    print("-Environment -isDebug:", isDebug)
  }
}
