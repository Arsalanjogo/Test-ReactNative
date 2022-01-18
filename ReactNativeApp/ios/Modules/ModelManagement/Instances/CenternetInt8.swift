//
//  CenternetInt8.swift
//  jogo
//
//  Created by arham on 26/10/2021.
//

import Foundation
import Accelerate
import CoreImage
import TensorFlowLite

class CenternetInt8: TFLiteDetector {
  
  init?() {
    super.init(confidenceScore: 0.40, modelName: "centernet-aug-v12-3-int8")
    self.inputWidth = 320
    self.inputHeight = 320
  }
  
  public enum ObserverID: Int {
    case FOOTBALL = 1000000
  }
  
  
  /// Returns the RGB data representation of the given image buffer with the specified `byteCount`.
  ///
  /// - Parameters
  ///   - buffer: The BGRA pixel buffer to convert to RGB data.
  ///   - byteCount: The expected byte count for the RGB data calculated using the values that the
  ///       model was trained on: `batchSize * imageWidth * imageHeight * componentsCount`.
  ///   - isModelQuantized: Whether the model is quantized (i.e. fixed point values rather than
  ///       floating point values).
  /// - Returns: The RGB data representation of the image buffer or `nil` if the buffer could not be
  ///     converted.
  override internal func rgbDataFromBuffer(
    _ buffer: CVPixelBuffer,
    byteCount: Int,
    isModelQuantized: Bool
  ) -> Data? {
    CVPixelBufferLockBaseAddress(buffer, .readOnly)
    defer {
      CVPixelBufferUnlockBaseAddress(buffer, .readOnly)
    }
    guard let sourceData = CVPixelBufferGetBaseAddress(buffer) else {
      return nil
    }
    
    let width = CVPixelBufferGetWidth(buffer)
    let height = CVPixelBufferGetHeight(buffer)
    let sourceBytesPerRow = CVPixelBufferGetBytesPerRow(buffer)
    let destinationChannelCount = 3
    let destinationBytesPerRow = destinationChannelCount * width
    
    var sourceBuffer = vImage_Buffer(data: sourceData,
                                     height: vImagePixelCount(height),
                                     width: vImagePixelCount(width),
                                     rowBytes: sourceBytesPerRow)
    
    guard let destinationData = malloc(height * destinationBytesPerRow) else {
      print("Error: out of memory")
      return nil
    }
    
    defer {
      free(destinationData)
    }
    
    var destinationBuffer = vImage_Buffer(data: destinationData,
                                          height: vImagePixelCount(height),
                                          width: vImagePixelCount(width),
                                          rowBytes: destinationBytesPerRow)
    
    if CVPixelBufferGetPixelFormatType(buffer) == kCVPixelFormatType_32BGRA {
      vImageConvert_BGRA8888toRGB888(&sourceBuffer, &destinationBuffer, UInt32(kvImageNoFlags))
    } else if CVPixelBufferGetPixelFormatType(buffer) == kCVPixelFormatType_32ARGB {
      vImageConvert_ARGB8888toRGB888(&sourceBuffer, &destinationBuffer, UInt32(kvImageNoFlags))
    }
    
    let byteData = Data(bytes: destinationBuffer.data, count: destinationBuffer.rowBytes * height)
    if isModelQuantized {
      return byteData
    }
    return byteData
  }
}
