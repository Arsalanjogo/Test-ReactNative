//
//  TFLiteModel.swift
//  jogo
//
//  Created by arham on 22/02/2021.
//

import Accelerate
import AVFoundation
import CoreImage
import Foundation
import TensorFlowLite

class TFLiteModel: Model {
  
  //https://github.com/tensorflow/examples/blob/master/lite/examples/image_classification/ios/ImageClassification/ModelDataHandler/ModelDataHandler.swift
  
  internal var detectionModel: Interpreter!
  var preProcessed: (image: CVPixelBuffer?, info: InfoBlob?)
  private var modelName: String?
  internal var processed: Bool = false
  private var modelProcessingQueue: DispatchQueue

  // MARK: Model parameters
  // Currently needed as the Interpreter in iOS does not have the api for getting the input layer dimensions.
  let batchSize = 1
  let inputChannels = 3

  // image mean and std for floating model, should be consistent with parameters used in model training
  let imageMean: Float = 127.5
  let imageStd: Float = 127.5

  private let bgraPixel = (channels: 4, alphaComponent: 3, lastBgrComponent: 2)
  private let rgbPixelChannels = 3
  private let colorStrideValue = 10
  
  /// Information about a model file or labels file.
  typealias FileInfo = (name: String, extension: String)
  
  init?(confidenceScore: Float, modelName: String, threadCount: Int = 2) {
    self.modelProcessingQueue = DispatchQueue(label: "ModelProcessingQueue",
                                              qos: .userInitiated,
                                              attributes: [],
                                              autoreleaseFrequency: .inherit,
                                              target: .global(qos: .userInitiated))
    super.init(confidenceScore: confidenceScore)
    self.modelName = modelName
    guard let modelPath = Bundle.main.path(forResource: self.modelName!, ofType: "tflite") else {
      return
    }
    
    var objOptions = Interpreter.Options()
    objOptions.threadCount = threadCount
    let metalDelegate = MetalDelegate()
    do {
        // Create the `Interpreter`.
        detectionModel = try Interpreter(modelPath: modelPath, options: objOptions, delegates: [metalDelegate])
        // Allocate memory for the model's input  `Tensor`s.
        try detectionModel.allocateTensors()
    } catch {
      Logger.shared.logError(error: error)
    }
  }
  
  public func runModel() { }
  
  override func supplyFrameInternal(sampleBuffer: ExtendedSampleBuffer) {
    self.modelProcessingQueue.async { [weak self] in
      let sTime = Date().getNanoseconds()
      let infoBlob: InfoBlob = InfoBlob(extendedSampleBuffer: sampleBuffer)
      let pixelBuffer: CVPixelBuffer? =  CMSampleBufferGetImageBuffer(sampleBuffer.getSampleBuffer())
      if pixelBuffer == nil {
        Logger.shared.log(logType: .INFO, message: "Could not convert ExtendedSampleBuffer to CVPixelBuffer...")
        return
      }
      self?.preProcessed = (image: pixelBuffer, info: infoBlob)
      self?.runModel()
      Profiler.get().profileTime(frameId: infoBlob.frameId!, tag: "supply-frame-tflite-model", delta: Date().getNanoseconds() - sTime)
    }
  }
}
