//
//  Strings.swift
//  NATIVE_AI
//
//  Created by Mac Book on 11/07/2020.
//

import Foundation
enum Strings: String {
  // SingleMethod For the Usage of Localization.
  var text: String { return NSLocalizedString( self.rawValue, comment: "") }
  case ALERT = "Alert"
  case OK = "Ok"

}

extension String {
  func getLocalizedString() -> String {
    switch Locale.current.languageCode {
    case "nl":
      return LocalizedStrings.dutch[self] ?? ""
    case "en":
      return LocalizedStrings.english[self] ?? ""
    default:
      return ""
    }
  }
}

class LocalizedStrings {
  static let english = [
    "Swipe to start recording": "Swipe to start recording",
    " Swipe to stop recording ": "Swipe to stop recording",
  ]
  
  static let dutch = [
    "Swipe to start recording": "Swipe om te beginnen met opnemen",
    " Swipe to stop recording ": "Swipe om te stoppen met opnemeng",
  ]
}
