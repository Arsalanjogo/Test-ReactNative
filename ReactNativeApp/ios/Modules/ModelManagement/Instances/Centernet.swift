//
//  Centernet.swift
//  jogo
//
//  Created by arham on 20/10/2021.
//

import Foundation
import Accelerate
import CoreImage
import TensorFlowLite

class Centernet: TFLiteDetector {
  
  init?() {
    super.init(confidenceScore: 0.55, modelName: "centernet-aug-v12-3")
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
    
    let bytes: [UInt8] = [UInt8](unsafeData: byteData)!
    var floats: [Swift.Float] = [Swift.Float](repeating: 0.0, count: bytes.count)
    vDSP_vfltu8(bytes, 1, &floats, 1, vDSP_Length(bytes.count))
    return Data(bytes: floats, count: floats.count * MemoryLayout<Float>.size)
  }
  
  
  override func formatResultsToDetectionArrayList(boundingBox: [Float],
                                                  outputClasses: [Float],
                                                  outputScores: [Float],
                                                  outputCount: Int,
                                                  width: CGFloat,
                                                  height: CGFloat,
                                                  frameId: Int) -> [DetectionLocation]? {
    var resultsArray: [DetectionLocation] = [DetectionLocation]()
    if outputCount == 0 {
      return resultsArray
    }
    for i in 0...(outputCount - 1) {
      
      let score = outputScores[i]
      
      // Filters results with confidence < threshold.
      guard score >= self.confidenceScore! else {
        continue
      }
      
      // Gets the output class names for detected classes from labels list.
      let outputClassIndex = Int(outputClasses[i])
      let outputClass = labels[outputClassIndex + 1]
      
      var rect: CGRect = CGRect.zero
      switch GameContext.getContext()?.cameraFacing ?? .BACK {
      case .FRONT:
        rect.origin.y = CGFloat(boundingBox[4 * i])
        rect.origin.x = CGFloat(1 - boundingBox[4 * i + 1])
        rect.size.height = CGFloat(boundingBox[4 * i + 2]) - rect.origin.y
        rect.size.width = CGFloat(1 - boundingBox[4 * i + 3]) - rect.origin.x
      default:
        rect.origin.y = CGFloat(boundingBox[4 * i])
        rect.origin.x = CGFloat(boundingBox[4 * i + 1])
        rect.size.height = CGFloat(boundingBox[4 * i + 2]) - rect.origin.y
        rect.size.width = CGFloat(boundingBox[4 * i + 3]) - rect.origin.x
      }
      // Translates the detected bounding box to CGRect.
      rect.origin.y = CGFloat(boundingBox[4 * i])
      let orientation = preProcessed.info?.cameraOrientation
      if orientation == .leftMirrored || orientation == .upMirrored || orientation == .downMirrored {
        rect.origin.x = 1 - CGFloat(boundingBox[4 * i + 1])
        rect.size.width = (1 - CGFloat(boundingBox[4 * i + 3])) - rect.origin.x
      } else {
        rect.origin.x = CGFloat(boundingBox[4 * i + 1])
        rect.size.width = CGFloat(boundingBox[4 * i + 3]) - rect.origin.x
      }
      rect.size.height = CGFloat(boundingBox[4 * i + 2]) - rect.origin.y
      
      // The detected corners are for model dimensions. So we scale the rect with respect to the
      // actual image dimensions.
      //      let newRect = rect.applying(CGAffineTransform(scaleX: width, y: height))
      
      let inference = RectLocation(
        rect: rect,
        classLabel: outputClass,
        frameId: frameId,
        confidence: score)
      resultsArray.append(inference)
    }
    
    // Sort results in descending order of confidence.
    resultsArray.sort { (first, second) -> Bool in
      return first.confidence > second.confidence
    }
    if resultsArray.count >= 1 {
    }
    return resultsArray
  }
}
