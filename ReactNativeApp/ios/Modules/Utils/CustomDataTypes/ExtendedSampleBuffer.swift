//
//   ExtendedSampleBuffer.swift
//   jogo
//
//   Created by arham on 22/02/2021.
//

import Foundation
import AVFoundation
import Accelerate

// public enum Orientation : Int {
//
//
// case up = 0
//
// case down = 1
//
// case left = 2
//
// case right = 3
//
// case upMirrored = 4
//
// case downMirrored = 5
//
// case leftMirrored = 6
//
// case rightMirrored = 7
//  }

public class ExtendedSampleBuffer {
  //  Saves the image and the corresponding information for the camera.
  
  private var frameID: Int?
  private var image: CMSampleBuffer?
  
  public final let screenOrientation: Int
  public final let cameraOrientation: UIImage.Orientation?
  private var mirrorX: Bool = false
  private var mirrorY: Bool = false
  
  
  public init(image: CMSampleBuffer, frameID: Int, screenOrientation: Int, isBackCamera: Bool, cameraOrientation: UIImage.Orientation) {
    self.image = image
    self.frameID = frameID
    self.screenOrientation = screenOrientation
    self.cameraOrientation = cameraOrientation
  }
  
  public func getFrameID() -> Int {
    return frameID != nil ? frameID! : 0
  }
  
  public func getSampleBufferDimensions() -> (Int, Int) {
    guard let imageBuffer = CMSampleBufferGetImageBuffer(image!) else {
      return (0, 0)
    }
    let width = CVPixelBufferGetWidth(imageBuffer)
    let height = CVPixelBufferGetHeight(imageBuffer)
    return (width, height)
    
  }
  
  public func getScreenOrientation() -> Int {
    return self.screenOrientation
  }
  
  public func getSampleBuffer() -> CMSampleBuffer {
    return self.image!
  }
  
}
