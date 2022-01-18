//
//  InfoBlob.swift
//  jogo
//
//  Created by arham on 22/02/2021.
//

import AVFoundation
import CoreFoundation
import Foundation

public class InfoBlob {
  // Infoblob saves the frame data.
  
  public final var frameId: Int?
  public final var startTime: UInt64 = UInt64(Date().getMilliseconds())
  public var doneProcessingTimestamp: UInt64?
  var infoString: String = ""
  private var width: Int?
  private var height: Int?
  private final var screenOrientation: Int?
  final var cameraOrientation: UIImage.Orientation
  
  public init(extendedSampleBuffer: ExtendedSampleBuffer) {
    self.frameId = extendedSampleBuffer.getFrameID()
    let dimensions = extendedSampleBuffer.getSampleBufferDimensions()
    self.width = dimensions.0
    self.height = dimensions.1
    self.screenOrientation = extendedSampleBuffer.getScreenOrientation()
    self.cameraOrientation = UIImage.Orientation(rawValue: screenOrientation!)!
  }
  
  public init(frameId: Int) {
    self.frameId = frameId
    self.cameraOrientation = .leftMirrored
    self.width = 1280
    self.height = 720
    self.screenOrientation = 1
  }
  
  public func sinceStart() -> UInt64 {
    return UInt64(Date().getMilliseconds()) - startTime
  }
  
  public func doneProcessing() {
    doneProcessingTimestamp = UInt64(Date().getMilliseconds())
  }
  
  public func addInfo(info: String) {
    infoString.append(String(format: "%@,", info))
  }
  
  public func toString() -> String {
    return String( format: "InfoBlob{ frameID=%d, startTime=%d, infoString=%@ }", frameId!, startTime, infoString)
  }
  
  public func getHeight() -> Int {
    return self.height!
  }
  
  public func getWidth() -> Int {
    return self.width!
  }
  
}
