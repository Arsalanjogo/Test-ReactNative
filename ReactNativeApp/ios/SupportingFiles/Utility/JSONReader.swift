//
//  JSONReader.swift
//  jogo
//
//  Created by Muhammad Nauman on 22/11/2021.
//

import Foundation

public class JSONReader {
  
  public static let shared = JSONReader()
  
  private init() {}
  
  public func getObject<T: Codable>(from jsonFile: String) -> T? {
    
    if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
      let fileURL = url.appendingPathComponent(jsonFile)
      if let data = try? Data(contentsOf: fileURL) {
        return try? JSONDecoder().decode(T.self, from: data)
      }
      return nil
    }
    return nil
  }
  
}
