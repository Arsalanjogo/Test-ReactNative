//
//  PhotoService.swift
//  jogo
//
//  Created by Mac Book on 18/08/2020.
//

import Foundation
//
//  PhotoServices.swift
//  ThumbnailTestProject
//
//  Created by David Seek on 10/12/17.
//  Copyright © 2017 David Seek. All rights reserved.
//

import AVFoundation
import Foundation
import MobileCoreServices
import UIKit

class PhotoServices: NSObject {
    
  static let shared = PhotoServices()
  
  internal var completion: ((URL) -> Void)!
  internal let picker = UIImagePickerController()
  
  override init() {
    
    super.init()
    
    self.picker.allowsEditing = false
    self.picker.modalPresentationStyle = .fullScreen
    self.picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
    self.picker.delegate = self
    
  }
  
  func getVideoFromCameraRoll(on: UIViewController, completion: @escaping (_ image: URL) -> Void) {
    
    self.picker.sourceType = .photoLibrary
    self.picker.mediaTypes = [kUTTypeMovie as String]
    
    DispatchQueue.main.async {
      on.present(self.picker, animated: true) {
        self.completion = completion
      }
    }
  }
}

// MARK: UIImagePickerControllerDelegate methods
extension PhotoServices: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
    if let url = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.mediaURL.rawValue)] as? URL {
      DispatchQueue.main.async {
        self.picker.dismiss(animated: true) {
          self.completion(url)
          
        }
      }
    }
  }
}

// MARK: Thumbnail
extension PhotoServices {
  func getThumbnailFrom(path: URL) -> UIImage? {
    do {
      let asset = AVURLAsset(url: path, options: nil)
      let imgGenerator = AVAssetImageGenerator(asset: asset)
      imgGenerator.appliesPreferredTrackTransform = true
      let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
      let thumbnail = UIImage(cgImage: cgImage)
      return thumbnail
    } catch let error {
      print("*** Error generating thumbnail: \(error.localizedDescription)")
      return nil
      
    }
  }
}
