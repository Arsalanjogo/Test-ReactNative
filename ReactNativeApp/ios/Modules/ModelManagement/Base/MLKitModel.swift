//
//  MLKitModel.swift
//  jogo
//
//  Created by arham on 22/02/2021.
//

import Foundation
import MLKitVision

class MLKitModel: Model {
  // Base MLKit Model with minimal MLKit logic added on top of Model.
  
  var preProcessed: (image: VisionImage?, info: InfoBlob?) // Variable which gets updated via the supplyFrame in Model method.
  internal var processed: Bool = false
  private var modelProcessingQueue: DispatchQueue
  
  override init(confidenceScore: Float) {
    self.modelProcessingQueue = DispatchQueue(label: "MLKitProcessingQueue",
                                              qos: .userInitiated,
                                              attributes: [.concurrent],
                                              autoreleaseFrequency: .inherit,
                                              target: .global(qos: .userInitiated))
    super.init(confidenceScore: confidenceScore)
  }
  
  public func runModel() {
  }
  
  // Overwrite this function
  public func preProcessImage(imageInfo: (esb: ExtendedSampleBuffer, ib: InfoBlob)) -> (image: VisionImage?, info: InfoBlob?) {
    return (image: nil, info: nil)
  }
  
  // Update preProcessed here.
  override func supplyFrameInternal(sampleBuffer: ExtendedSampleBuffer) {
    self.modelProcessingQueue.async { [weak self] in
      guard let mlkitModel = self else { return }
      let sTime = Date().getNanoseconds()
      let infoBlob: InfoBlob = InfoBlob(extendedSampleBuffer: sampleBuffer)
      mlkitModel.preProcessed = mlkitModel.preProcessImage(imageInfo: (esb: sampleBuffer, ib: infoBlob))
      mlkitModel.processed = false
      mlkitModel.runModel()
      Profiler.get().profileTime(frameId: infoBlob.frameId!, tag: "supply-frame-mlkit-model", delta: Date().getNanoseconds() - sTime)
    }
  }
}
