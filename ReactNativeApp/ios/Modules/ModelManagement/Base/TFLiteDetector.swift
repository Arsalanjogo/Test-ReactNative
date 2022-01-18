//
//  TFLiteDetector.swift
//  jogo
//
//  Created by arham on 23/04/2021.
//

import Accelerate
import CoreImage
import TensorFlowLite
import UIKit

/// Stores one formatted inference.
struct Inference {
  let confidence: Float
  let className: String
  let rect: CGRect
}

class TFLiteDetector: TFLiteModel {
  /// Base Model for the all TFLite Object Detection models.
  
  internal var labels: [String] = []
  var inputWidth: Int = 0
  var inputHeight: Int = 0
  var maxDetection: Int = 10 /// Per frame/image. Any more will not be considered
  internal var busy: Bool = false
  var startTime = Date().getMilliseconds()
    
  init?(confidenceScore: Float, modelName: String) {
    super.init(confidenceScore: confidenceScore, modelName: modelName)
    loadLabels(fileInfo: (name: modelName, extension: "txt"))
    
  }
  
  /// Loads the labels from the labels file and stores them in the `labels` property.
  private func loadLabels(fileInfo: FileInfo) {
    let filename = fileInfo.name
    let fileExtension = fileInfo.extension
    guard let fileURL = Bundle.main.url(forResource: filename, withExtension: fileExtension) else {
      fatalError("Labels file not found in bundle. Please add a labels file with name " +
                  "\(filename).\(fileExtension) and try again.")
    }
    do {
      let contents = try String(contentsOf: fileURL, encoding: .utf8)
      labels = contents.components(separatedBy: .newlines)
    } catch {
      Logger.shared.logError(logType: .ERROR, error: error, extraMsg: "Labels file named \(filename).\(fileExtension) cannot be read. Please add a " +
                              "valid labels file and try again.")
      fatalError("Labels file named \(filename).\(fileExtension) cannot be read. Please add a " +
                  "valid labels file and try again.")
    }
  }
  
  override func runModel() {
    /// Get the frame from the preProcessed object which gets updated from the ModelManager.
    /// Convert the image into the proper format. Normalize it and post-process the results
    /// Distribute the results.
    
    if !running { return }
    if busy { return }
    
    let sTime = Date().getNanoseconds()
    let pixelBuffer = preProcessed.image!
    let frameId = preProcessed.info!.frameId
    let imageWidth = CVPixelBufferGetWidth(pixelBuffer)
    let imageHeight = CVPixelBufferGetHeight(pixelBuffer)
    let sourcePixelFormat = CVPixelBufferGetPixelFormatType(pixelBuffer)
    assert(sourcePixelFormat == kCVPixelFormatType_32ARGB ||
            sourcePixelFormat == kCVPixelFormatType_32BGRA ||
            sourcePixelFormat == kCVPixelFormatType_32RGBA)
    
    let imageChannels = 4
    assert(imageChannels >= inputChannels)
    
    // Crops the image to the biggest square in the center and scales it down to model dimensions.
    let scaledSize = CGSize(width: inputWidth, height: inputHeight)
    
    guard let scaledPixelBuffer = pixelBuffer.resizeImage(to: scaledSize) else {
      Logger.shared.log(logType: .WARN, message: "FAILED")
      busy = false
      return
    }
    
    let outputBoundingBox: Tensor
    let outputClasses: Tensor
    let outputScores: Tensor
    let outputCount: Tensor
    do {
      let inputTensor = try self.detectionModel.input(at: 0)
      // Remove the alpha component from the image buffer to get the RGB data.
      guard let rgbData = rgbDataFromBuffer(
        scaledPixelBuffer,
        byteCount: batchSize * inputWidth * inputHeight * inputChannels,
        isModelQuantized: inputTensor.dataType == .uInt8
      ) else {
        Logger.shared.logError(text: "Failed to convert the image buffer to RGB data.")
        busy = false
        return
      }
      try self.detectionModel.copy(rgbData, toInputAt: 0)
      try self.detectionModel.invoke()
      
      outputBoundingBox = try self.detectionModel.output(at: 0)
      outputClasses = try self.detectionModel.output(at: 1)
      outputScores = try self.detectionModel.output(at: 2)
      outputCount = try self.detectionModel.output(at: 3)
    } catch let error {
      Logger.shared.logError(logType: .ERROR, error: error, extraMsg: "Failed to invoke the interpreter with error")
      busy = false
      return
    }
    
    // Formats the results
    let resultArray: [DetectionLocation]? = formatResultsToDetectionArrayList(
      boundingBox: [Float](unsafeData: outputBoundingBox.data) ?? [],
      outputClasses: [Float](unsafeData: outputClasses.data) ?? [],
      outputScores: [Float](unsafeData: outputScores.data) ?? [],
      outputCount: Int(([Float](unsafeData: outputCount.data) ?? [0])[0]),
      width: CGFloat(imageWidth),
      height: CGFloat(imageHeight),
      frameId: frameId!
    )
    do {
      busy = false
      Logger.shared.logFPSEveryNSeconds(msg: "Football FPS")
      if resultArray == nil { return }
      try distributeLocations(argPair: (resultArray!, preProcessed.info!))
    } catch ModelErrors.frameRaceConditionAchieved {
      Logger.shared.logError(text: "TFLite: Race Condition Achieved!!")
    } catch {
      Logger.shared.logError(error: error)
    }
    Profiler.get().profileTime(frameId: self.preProcessed.info?.frameId ?? 0, tag: "tflite-detector", delta: Date().getNanoseconds() - sTime)
  }
  
  func formatResultsToDetectionArrayList(boundingBox: [Float],
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
  internal func rgbDataFromBuffer(
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
    var imageMean: Float = -self.imageMean
    var imageStride: Float = 1 / self.imageStd
    let n = vDSP_Length(floats.count)
    vDSP_vsadd(floats, 1, &imageMean, &floats, 1, n)
    vDSP_vsmul(floats, 1, &imageStride, &floats, 1, n)
    return Data(bytes: floats, count: floats.count * MemoryLayout<Float>.size)
  }
}
