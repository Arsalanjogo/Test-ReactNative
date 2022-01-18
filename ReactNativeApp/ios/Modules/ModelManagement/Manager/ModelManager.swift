//
//  ModelManager.swift
//  jogo
//
//  Created by Muhammad Nauman on 07/11/2020.
//

import Foundation

enum ModelManagerErrors: Error {
  case invalidModelName
  case noExerciseLead
  case multipleExerciseLead
  case modelAlreadyRunning
  case cannotLoadModel
  case unimplementedModel
}

var modelManagerQueue: DispatchQueue?

class ModelManager {
  // The core manager of all models which can be availabe for the exercise.
  // Links the Object Representations with the associated Models and instantiates
  // them if they are not present.
  
  public enum MODELTYPE {
    case FOOTBALLv16
    case FOOTBALLvCNET
    case FOOTBALLvCNET16
    case FOOTBALLvCNET8
    case POSENET
    case POSENETSINGLEIMAGE
    case POSENETFAST
    case SKIP
  }
  
  private var iostream: IOStream?
  private var modelMap = [MODELTYPE: Model]()
  private static var modelManager: ModelManager?  // Current static instance of self. Used as a singeleton
  public var exiting = false
  
  // MARK: Lifecycle
  // Constructor
  private init(iostream: IOStream) {
    self.iostream = iostream
    if modelManagerQueue == nil {
      modelManagerQueue = DispatchQueue(label: "ModelManager", qos: .userInitiated, attributes: [], autoreleaseFrequency: .inherit, target: .global(qos: .userInitiated))
    } else {
      modelManagerQueue?.resume()
    }
  }
  
  public static func getInstance() -> ModelManager? {
    return modelManager
  }
  
  public static func createInstance(ioStream: IOStream) -> ModelManager {
    if modelManager == nil {
      modelManager = ModelManager(iostream: ioStream)
    }
    return modelManager!
  }
  
  public func reset() {
    modelMap.forEach { (_: MODELTYPE, model: Model) in
      model.reset()
    }
  }
  
  public static func removeInstance() {
    modelManager = nil
  }
  
  public func exit() {
    self.exiting = true
  }
  
  deinit {
    modelManagerQueue?.suspend()
    Logger.shared.log(logType: .INFO, message: "Model Manager deinit")
  }
  
  // MARK: Model Lifecylce
  
  public func instantiateModel(modelManagerType: MODELTYPE) throws -> Model? {
    var model: Model?
    switch modelManagerType {
    case .POSENET:
      model = Posenet()
    case .POSENETFAST:
      model = PosenetNormal()
    case .POSENETSINGLEIMAGE:
      model = PosenetSingleImage()
    case .FOOTBALLv16:
      model = Football()!
    case .FOOTBALLvCNET:
      model = Centernet()!
    case .FOOTBALLvCNET16:
      model = CenternetFP16()!
    case .FOOTBALLvCNET8:
      model = CenternetInt8()!
    case .SKIP:
      model = nil
      throw ModelManagerErrors.unimplementedModel
    }
    return model
  }
  
  func start() throws {
    if modelMap.values.count == 1 {
      let model: Model = Array(modelMap.values)[0]
      model.setExerciseLead(exerciseLead: true)
    }
    
    let leadModelCount: Int = Array(self.modelMap.values).filter { $0.isExerciseLead() }.count
    
    if leadModelCount == 0 { throw ModelManagerErrors.noExerciseLead }
    if leadModelCount > 1 { throw ModelManagerErrors.multipleExerciseLead }
    
    modelManagerQueue?.async { [unowned self] in
      DispatchQueue.concurrentPerform(iterations: self.modelMap.values.count, execute: { index in
          Array(self.modelMap.values)[index].start()
      })
    }
  }
  
  public func stop() {
    modelManagerQueue?.sync {[unowned self] in
      DispatchQueue.concurrentPerform(iterations: self.modelMap.values.count, execute: { index in
          Array(self.modelMap.values)[index].stop()
      })
    }
    modelMap = [MODELTYPE: Model]()
  }
  
  public func getModels() -> [Model] {
    return Array(modelMap.values)
  }
  
  public func setExerciseLead(modelType: MODELTYPE, exerciseLead: Bool) {
    guard isNotNil(modelType: modelType) else { return }
    modelMap[modelType]!.setExerciseLead(exerciseLead: exerciseLead)
  }
  
  public func subscribe(observer: ModelObserver) {
    let modelType: MODELTYPE = observer.getModelType()
    guard modelType != MODELTYPE.SKIP else { return }
    
    var model: Model? = modelMap[modelType]
    if model == nil {
      do {
        try model = instantiateModel(modelManagerType: modelType)!
      } catch ModelManagerErrors.invalidModelName {
        Logger.shared.logError(text: "The model name was invalid: \(modelType)")
        return
      } catch {
        Logger.shared.logError(logType: .ERROR, error: error)
        print("Unexpected error: \(error).")
        return
      }
      model!.loadModel()
      model!.setIoStream(iostream: iostream!)
      model!.start()
      modelMap[modelType] = model!
    }
    model!.addObserver(observer: observer)
  }
  
  public func unsubscribe(observer: ModelObserver) {
    let modelType: MODELTYPE = observer.getModelType()
    guard modelType != MODELTYPE.SKIP else { return }
    let model: Model? = modelMap[modelType]
    guard model != nil else { return }
    model!.removeObserver(observer: observer)
    model!.unsetIoStream()
  }
  
  public func setIOStream(ioStream: IOStream) {
      self.iostream = ioStream
      self.modelMap.forEach { (_: MODELTYPE, model: Model) in
        model.setIoStream(iostream: ioStream)
      }
    }
  
  // MARK: Utility
  
  private func isNotNil(modelType: MODELTYPE) -> Bool {
    guard modelType != MODELTYPE.SKIP else { return false }
    guard modelMap.keys.contains(modelType) else { return false }
    guard modelMap[modelType] != nil else { return false }
    return true
  }
  
  public func setConfidenceScore(observer: ModelObserver, confidence: Float) {
    let modelType: MODELTYPE = observer.getModelType()
    guard isNotNil(modelType: modelType) else { return }
    modelMap[modelType]?.setConfidenceScore(confidenceScore: confidence)
  }
  
  public func removeConfidenceScore(observer: ModelObserver) {
    let modelType: MODELTYPE = observer.getModelType()
    guard isNotNil(modelType: modelType) else { return }
    modelMap[modelType]?.removeConfidenceScore()
  }
  
  public func setMaxFps(fps: Int, modelType: MODELTYPE) {
    self.modelMap[modelType]!.setMaxFps(fps: fps)
  }
  
  // MARK: Frame flow
  public func supplyFrame(sampleBuffer: ExtendedSampleBuffer) {
    let observedLeadModels: Int = Array(self.modelMap.values)
      .filter({ (model) -> Bool in
        return !model.observers.isEmpty && model.isExerciseLead()
      }).count
    if observedLeadModels >= 2 { Logger.shared.log(logType: .ERROR, message: "Why are there \(observedLeadModels) leads?? ") }
    if observedLeadModels == 0 {
      Logger.shared.log(logType: .ERROR, message: "\(observedLeadModels) leads??. Exercise will not function.")
      return
    }
    DispatchQueue.concurrentPerform(iterations: modelMap.values.count, execute: { index in
      let model: Model? = Array(self.modelMap.values)[index]
      if !(model!.observers.isEmpty) {
        model!.supplyFrame(sampleBuffer: sampleBuffer)
      }
    })
  }
}
