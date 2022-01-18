//
//  ImageToRecord.swift
//  jogo
//
//  Created by Muhammad Nauman on 30/08/2021.
//

import AVFoundation
import Foundation

class ImageToRecord {
  
  var cameraFrame: UIImage?
  var blendedImage: CVPixelBuffer?
  var presentationTime: CMTime
  static var viewFrame: UIImage?
  
  init(cameraFrame: UIImage, presentationTime: CMTime) {
    self.cameraFrame = cameraFrame
    self.presentationTime = presentationTime
  }
  
}
