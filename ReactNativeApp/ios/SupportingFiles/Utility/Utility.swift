//
//  Utility.swift
//  Jogo
//
//  Created by Mac Book on 10/07/2020.
//

import AVFoundation
import Foundation
import UIKit

fileprivate struct TimeData {
  let seconds: Int
  let minutes: Int
  let hours: Int
}

@objc class Utility: NSObject {
  static let main = Utility()
  fileprivate override init() {}
}

extension Utility {
  func randomString(length: Int) -> String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    return String((0..<length).map { _ in letters.randomElement()! })
  }
}
extension Utility {
  func digitalClockTime(seconds: Int) -> String {
    if seconds >= 0 {
      let timeData: TimeData = self.secondsToHoursMinutesSeconds(seconds: seconds)
      let min = timeData.minutes > 9 ? "\(timeData.minutes)" : "0\(timeData.minutes)"
      let sec = timeData.seconds > 9 ? "\(timeData.seconds)" : "0\(timeData.seconds)"
      return "\(min):\(sec)"
    }
    return "00:00"
  }
  private func secondsToHoursMinutesSeconds (seconds: Int) -> TimeData {
    return TimeData(seconds: (seconds % 3600) % 60, minutes: (seconds % 3600) / 60, hours: seconds / 3600)
  }
}
// MARK: Alert related functions
extension Utility {
  
  func showAlert(message: String, title: String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: Strings.OK.text, style: .default, handler: nil))
    Utility.main.topViewController()?.present(alertController, animated: true, completion: nil)
  }
}
 // MARK: Top View Controller

extension Utility {
  func topViewController(base: UIViewController? = (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController) -> UIViewController? {
    if let nav = base as? UINavigationController {
      return topViewController(base: nav.visibleViewController)
    }
    if let tab = base as? UITabBarController {
      if let selected = tab.selectedViewController {
        return topViewController(base: selected)
      }
    }
    if let presented = base?.presentedViewController {
      return topViewController(base: presented)
    }
    return base
  }
}
extension Utility {
  func generateThumbnail(path: URL) -> String? {
    do {
      let asset = AVURLAsset(url: path, options: nil)
      let imgGenerator = AVAssetImageGenerator(asset: asset)
      imgGenerator.appliesPreferredTrackTransform = true
      let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 6, timescale: 1), actualTime: nil)
      let thumbnail = UIImage(cgImage: cgImage)
      let thumbnailImageData = thumbnail.jpegData(compressionQuality: 0.1) ?? Data()
      let thumbnailImageDataBase64 = thumbnailImageData.base64EncodedString()
      return thumbnailImageDataBase64
    } catch let error {
      Logger.shared.logError(logType: .ERROR, error: error, extraMsg: "Error generating thumbnail!")
      return nil
    }
  }
  func getThumbnailImageFromVideoUrl(url: URL, completion: @escaping ((_ image: UIImage?) -> Void)) {
    DispatchQueue.global().async { // 1
      let asset = AVAsset(url: url) // 2
      let avAssetImageGenerator = AVAssetImageGenerator(asset: asset) // 3
      avAssetImageGenerator.appliesPreferredTrackTransform = true // 4
      let thumnailTime = CMTimeMake(value: 2, timescale: 1) // 5
      do {
        let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil) // 6
        let thumbImage = UIImage(cgImage: cgThumbImage) // 7
        DispatchQueue.main.async { // 8
          completion(thumbImage) // 9
        }
      } catch {
        Logger.shared.logError(logType: .ERROR, error: error, extraMsg: "Could not get thumbnail!")
        DispatchQueue.main.async {
          completion(nil) // 11
        }
      }
    }
  }
  func generateThumbnails(url: URL) -> UIImage? {
    do {
      let asset = AVURLAsset(url: url)
      let imageGenerator = AVAssetImageGenerator(asset: asset)
      imageGenerator.appliesPreferredTrackTransform = true
      // Select the right one based on which version you are using
      // Swift 4.2
      let cgImage = try imageGenerator.copyCGImage(at: .zero,
                                                   actualTime: nil)
      return UIImage(cgImage: cgImage)
    } catch {
      Logger.shared.logError(logType: .ERROR, error: error, extraMsg: "Error generating thumbnail CGImage!")
      return nil
    }
  }
}
import AVKit

extension AVAsset {
  func generateThumbnail(completion: @escaping (UIImage?) -> Void) {
    DispatchQueue.global().async {
      let imageGenerator = AVAssetImageGenerator(asset: self)
      let time = CMTime(seconds: 0.0, preferredTimescale: 600)
      let times = [NSValue(time: time)]
      imageGenerator.generateCGImagesAsynchronously(forTimes: times, completionHandler: { _, image, _, _, _ in
        if let image = image {
          completion(UIImage(cgImage: image))
        } else {
          completion(nil)
        }
      })
    }
  }
}
