//
//  Model.swift
//  jogo
//
//  Created by arham on 22/02/2021.
//

import Foundation


public enum ModelErrors: Error {
  case frameRaceConditionAchieved
}

class Model: ObservableModel {
  
  // Base class for all models. Allows interfacing functionality for all models built
  // on top of it.
  // Provides func. for add/removal of observers to models for notificaiton.
  // Provides interface for receiving frames from model manager.
  // Allows model setting to proimary or secondary to lead the exercise.
  // Processes notification process in its own queue.
  
  
  // MARK: Variables
  internal var confidenceScore: Float?
  private var exerciseLead: Bool = false
  internal var running: Bool = false
  private var lastId: Int = 0
  internal var maxFps: Int = -1
  internal var fpsTimePeriod: Double = 0
  internal var lastFrameTime: Double = 10000
  internal final var observers: [ModelObserver] = [ModelObserver]()
  
  // Delegate
  internal var iostream: IOStream?
  
  // Queue
  var modelQueue: DispatchQueue?
  
  // MARK: Lifecycle
  // Model is initialized with only the confidence score and a queue.
  public init(confidenceScore: Float) {
    self.confidenceScore = confidenceScore
    modelQueue = DispatchQueue(label: "ModelQueue", qos: .default, attributes: .concurrent, autoreleaseFrequency: .inherit, target: .none)
  }
  
  func start() {
    running = true
    
  }
  
  func stop() {
    running = false
  }
  
  func loadModel() {
  }
  
  func reset() {
    self.lastId = 0
    self.lastFrameTime = 10000
  }
  
  // MARK: Distribute Location Logic
   func setIoStream(iostream: IOStream) {
     self.iostream = iostream
   }
   
   func unsetIoStream() {
     self.iostream = nil
   }
  
  // MARK: Properties
  
  public func setConfidenceScore(confidenceScore: Float) {
    self.confidenceScore = confidenceScore
  }
  
  public func setExerciseLead(exerciseLead: Bool) {
    self.exerciseLead = exerciseLead
  }
  
  public func isExerciseLead() -> Bool {
    return self.exerciseLead
  }
  
  func removeConfidenceScore() {
    confidenceScore = 0.0
  }
  
  func setMaxFps(fps: Int) {
    self.maxFps = fps
    self.fpsTimePeriod = 1000.0 / Double(fps)
  }
  
  // MARK: Observer CRUD
  
  func addObservers(observers: [ModelObserver]) {
    for observer in observers {
      self.addObserver(observer: observer)
    }
  }
  
  func removeObservers(observers: [ModelObserver]) {
    observers.forEach { (observer) in
      self.removeObserver(observer: observer)
    }
  }
  
  func addObserver(observer: ModelObserver) {
    self.observers.append(observer)
    observer.setModel(model: self)
  }
  
  func removeObserver(observer: ModelObserver) {
    var removableIndex: Int = -1
    for (index, registeredObserver) in self.observers.enumerated() where registeredObserver.id == observer.id {
      removableIndex = index
      break
    }
    guard removableIndex != -1 else { return }
    self.observers.remove(at: removableIndex)
  }

  // MARK: After Processing Step
  
  func notifyListeners(locations: [DetectionLocation], infoBlob: InfoBlob) {
    let sTime = Date().getNanoseconds()
    DispatchQueue.concurrentPerform(iterations: self.observers.count) { [weak self] (index) in
      if (self?.observers.count)! >= index {
        if self?.observers[index] != nil {
          self?.observers[index].parse(detectedLocations: locations, infoBlob: infoBlob)
        }
      }
    }
    ExerciseStatsJsonManager.get().insertAllDetections(values: locations)
    Profiler.get().profileTime(frameId: infoBlob.frameId!, tag: "notify-listener", delta: Date().getNanoseconds() - sTime)
  }
  
  internal func distributeLocations(argPair: ([DetectionLocation], InfoBlob)?) throws {
    guard argPair != nil else { return }
    modelQueue?.sync {
      argPair?.1.doneProcessing()
    }
    ObjectDetection.updaterQ.sync {
      notifyListeners(locations: argPair!.0, infoBlob: argPair!.1)
    }
    
    if exerciseLead {
      modelQueue?.async { [weak self] in
        self?.iostream?.onImageProcessed(infoBlob: argPair!.1)
        
      }
    }
    
    if lastId > argPair!.1.frameId! {
      throw ModelErrors.frameRaceConditionAchieved
    }
    lastId = argPair!.1.frameId!
    Logger.shared.logFPSEveryNSeconds(seconds: 15, msg: "Distribute Location", value: 1)
  }

  // MARK: Preprocessing Step
  func supplyFrame(sampleBuffer: ExtendedSampleBuffer) {
    guard running else { return }
    
    let tTemp: Double = Date().getMilliseconds() - lastFrameTime
    
    if self.maxFps != -1 && tTemp < self.fpsTimePeriod { return }
    
    lastFrameTime = Date().getMilliseconds()
    if isExerciseLead() {
      supplyFrameInternal(sampleBuffer: sampleBuffer)
    } else {
      DispatchQueue.global(qos: .utility).async { [unowned self] in
        supplyFrameInternal(sampleBuffer: sampleBuffer)
      }
    }
  }
  
  func supplyFrameInternal(sampleBuffer: ExtendedSampleBuffer) { }
}
