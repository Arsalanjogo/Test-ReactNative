//
//  ThemeManager.swift
//  jogo
//
//  Created by Muhammad Nauman on 26/07/2021.
//

import Foundation

@objc class ThemeManager: NSObject {
  
  @objc var theme: Theme!
  @objc static let shared = ThemeManager()
  
  private override init() {
    
  }
  
}
