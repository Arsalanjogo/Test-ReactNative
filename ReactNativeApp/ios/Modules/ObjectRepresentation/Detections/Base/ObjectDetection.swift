//
//  ObjectDetection.swift
//  jogo
//
//  Created by Muhammad Nauman on 21/11/2020.
//

import Foundation

class ObjectDetection: ModelObserver, CanDraw, MovingObject, Hashable, Equatable {
  // Base Object Representation Class which collates functionality needed in all childs into one.
  // Can subscribe/unsubscribe to the relevant model.
  // Can parse the information into relevant containers which have their own interfaces for get/set.
  // Has a base drawing functionality.
  // Can convert the basic data version into its appropriate JSON version.
  static func == (lhs: ObjectDetection, rhs: ObjectDetection) -> Bool {
    lhs.id == rhs.id && lhs.label == rhs.label && lhs.modelType == rhs.modelType
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
    hasher.combine(label)
    hasher.combine(modelType)
  }
  
  var id: Int
  var label: String
  var modelType: ModelManager.MODELTYPE
  var exerciseLead: Bool
  
  final let OLDESTPROCESSIBLELOCATION: Int = 30
  final var BUFFERLENGTH: Int = -1
  final var INFERLOOKBACK: Int = 10
  public final var OUTLIERMULTIPLIER: Int = 10
  public final var OUTLIERMINDETECTIONS: Int = 20
  public final var OUTLIERLOOKBACK: Int = 3
  private var avgFrameDistance: Double = 0
  private var detectedCount: Int = 0
  private var frameInferenceCount: Int = 0
  private var skippedFrameCount: Int = 0
  internal final var infoBlobArrayList: UtilArrayList<InfoBlob> = UtilArrayList<InfoBlob>()
  var inferLocation: InferLocation = InferLocationLinear()
  private var confidenceScore: Float = 0.0
  
  public static var xScale = 1.0
  public static var yScale = 1.0
  public static var screenSize = CGSize.zero
  
  internal var model: ObservableModel?
  internal var locations: UtilArrayList<DetectionLocation> = UtilArrayList<DetectionLocation>()
  private var newestLocation: DetectionLocation?
  static let updaterQ = DispatchQueue(label: "UpdaterQueue", qos: .default, attributes: [], autoreleaseFrequency: .inherit, target: .none)
  private static var mutex = Mutex()
  
  // MARK: Lifecycle
  init(label: String, modelType: ModelManager.MODELTYPE, exerciseLead: Bool, observerId: Int, testing: Bool = false) {
    self.id = observerId
    self.label = label
    self.modelType = modelType
    self.exerciseLead = exerciseLead
    self.infoBlobArrayList.setMaxSize(value: BUFFERLENGTH)
    self.locations.setMaxSize(value: BUFFERLENGTH)
    if !testing {
      let manager: ModelManager = ModelManager.getInstance()!
      manager.subscribe(observer: self)
      setExerciseLead(exerciseLead: exerciseLead)
    }
  }
  
  public func unsubscribe() {
    let modelManager: ModelManager? = ModelManager.getInstance()
    guard modelManager != nil else { return }
    modelManager!.unsubscribe(observer: self)
    self.unsetModel()
  }
  
  func unsetModel() {
    model = nil
  }
  
  func setModel(model: ObservableModel) {
    self.model = model
  }
  
  // MARK: Location Get/Set
  
  public func frameDiffCheck(loc: DetectionLocation?) -> DetectionLocation? {
    let currentFrameVal: Int? = ExerciseViewController.baseViewController?.getCurrentFrameValue()
    if (currentFrameVal ?? 10_000) - (loc?.frameId ?? 0) > OLDESTPROCESSIBLELOCATION { return nil }
    return loc
  }
  
  public func getLocation() -> DetectionLocation? {
    do {
      let loc: DetectionLocation? = try self.locations.getLast()
      return frameDiffCheck(loc: loc)
    } catch {
      return nil
    }
  }
  
  func getLabel() -> String {
    return self.label
  }
  
  public func getDetectedLocation() -> DetectionLocation? {
    let detLoc: DetectionLocation? = getDetectionLocationNBack(lookBack: 0)
    
    return frameDiffCheck(loc: detLoc)
  }
  
  private func getKnownLocationOfNSize(interArray: [DetectionLocation], lookBack: Int) -> [DetectionLocation] {
    var count = 0
    var detLocArray: [DetectionLocation] = [DetectionLocation]()
    for i in 0..<interArray.count {
      let k: Bool = interArray[i].locationKnown()
      if k {
        count += 1
        detLocArray.append(interArray[i])
      }
      if count == lookBack {
        break
      }
    }
    return detLocArray
  }
  
  public func getDetectionLocationNBack(lookBack: Int) -> DetectionLocation? {
    let size: Int = self.locations.count()
    if size == 0 || size < lookBack { return nil }
    var interArray: [DetectionLocation] = self.locations.getReversed()
    if interArray.count > 15 { interArray = Array(interArray[0 ..< 15]) }
    
    let detLocArray: [DetectionLocation] = getKnownLocationOfNSize(interArray: interArray, lookBack: lookBack + 1)
    if detLocArray.isEmpty { return nil }
    if detLocArray.count <= lookBack { return nil }
    return detLocArray[lookBack]
  }
  
  public func getNDetectionLocations(locationCount: Int) -> UtilArrayList<DetectionLocation>? {
    guard locationCount < self.locations.count() else { return nil }
    let interArray: [DetectionLocation] = self.locations.getReversed()
    let detLocArray: [DetectionLocation] = getKnownLocationOfNSize(interArray: interArray, lookBack: locationCount)
    
    if detLocArray.isEmpty || detLocArray.count < locationCount {
      return nil
    }
    let filtered_array: [DetectionLocation] = Array(detLocArray.prefix(upTo: locationCount))
    return UtilArrayList<DetectionLocation>(values: filtered_array)
  }
  
  public func getNLocations(locationCount: Int) -> UtilArrayList<DetectionLocation>? {
    guard locationCount < self.locations.count() else { return nil }
    let detectLocArray: [DetectionLocation] = Array(self.locations.get().suffix(from: self.locations.count() - locationCount))
    return UtilArrayList<DetectionLocation>(values: detectLocArray)
  }
  
  public func getKnownLastN(locationCount: Int) -> UtilArrayList<DetectionLocation>? {
    guard locationCount < self.locations.count() else { return nil }
    let temp: [DetectionLocation] = self.getNLocations(locationCount: locationCount)!.get().filter({ $0.locationKnown() })
    return UtilArrayList<DetectionLocation>(values: temp)
  }
  
  public func getAllLocations() -> UtilArrayList<DetectionLocation> {
    return self.locations
  }
  
  public func getFrameInferenceCount() -> Int {
    return self.frameInferenceCount
  }
  
  public func getSkippedFrameCount() -> Int {
    return self.skippedFrameCount
  }
  
  public func getDetectedCount() -> Int {
    return self.detectedCount
  }
  
  public func getInfoBlobArrayList() -> UtilArrayList<InfoBlob> {
    return self.infoBlobArrayList
  }
  
  public func getLocations() -> UtilArrayList<DetectionLocation> {
    return self.locations
  }
  
  public func getY() -> Double? {
    if newestLocation != nil {
      let newIsNew = self.frameDiffCheck(loc: newestLocation)
      if newIsNew != nil { return newestLocation?.getY() } else {
        newestLocation = nil
      }
    }
    let detLoc: DetectionLocation? = self.getDetectedLocation()
    guard detLoc != nil else { return nil }
    return detLoc?.getY()
  }
  
  public func getX() -> Double? {
    if newestLocation != nil {
      let newIsNew = self.frameDiffCheck(loc: newestLocation)
      if newIsNew != nil { return newestLocation?.getX() } else {
        newestLocation = nil
      }
    }
    let detLoc: DetectionLocation? = self.getDetectedLocation()
    guard detLoc != nil else { return nil }
    return detLoc?.getX()
  }
  
  func missingLocation(frameId: Int) {
    self.locations.add(index: 0, value: MissingLocation(classLabel: self.label, frameId: frameId))
  }
  
  func processCheck(curDetLoc: DetectionLocation, bestMatch: DetectionLocation?, lastLocation: DetectionLocation?, minDistance: Double) -> Bool {
    return (curDetLoc.getLabel() == self.label && !curDetLoc.isProcessed() &&
              curDetLoc.getConfidence() >= self.confidenceScore &&
              (bestMatch == nil ||
                lastLocation == nil ||
                curDetLoc.getEuclideanDistance(location: lastLocation!) < minDistance ))
  }
  
  // MARK: Parse Info from Model
  func parse(detectedLocations: [DetectionLocation], infoBlob: InfoBlob) {
    self.frameInferenceCount += 1
    let temp: DetectionLocation? = self.getDetectedLocation()
    let lastProcessedFrameId = temp == nil ? -1 : temp!.getFrameId()
    
    self.infoBlobArrayList.add(index: 0, value: infoBlob)
    let lastLocation: DetectionLocation? = self.getDetectedLocation()
    
    var bestMatch: DetectionLocation?
    var minDistance: Double = 0
    
    let missingFrameDiff: Int = infoBlob.frameId! - lastProcessedFrameId - 1
    if missingFrameDiff < 0 {
      return
    }
    self.skippedFrameCount += missingFrameDiff
    
    detectedLocations.forEach { (curDetLoc) in
      if processCheck(curDetLoc: curDetLoc, bestMatch: bestMatch, lastLocation: lastLocation, minDistance: minDistance) {
        bestMatch = curDetLoc
        minDistance = bestMatch!.getEuclideanDistance(location: curDetLoc)
        newestLocation = curDetLoc
      }
    }
    if missingFrameDiff <= 0 { return }
    
    if bestMatch == nil {
      for i: Int in 0...missingFrameDiff {
        self.missingLocation(frameId: lastProcessedFrameId + i + 1)
      }
      self.missingLocation(frameId: infoBlob.frameId!)
      return
    }
    
    if lastLocation != nil {
      self.avgFrameDistance = (self.avgFrameDistance + bestMatch!.getEuclideanDistance(location: lastLocation!)) / (2.0)
    }
    
    bestMatch!.process()
    addDetectionLocation(detectedLocation: bestMatch!)
  }
  
  public func addDetectionLocation(detectedLocation: DetectionLocation) {
    let temp: UtilArrayList<DetectionLocation>? = self.getNLocations(locationCount: INFERLOOKBACK)
    if temp == nil {
      self.locations.add(index: 0, value: detectedLocation)
      return
    }
    inferLocation.infer(before: temp!, known: detectedLocation)
    self.locations.add(index: 0, value: detectedLocation)
  }
  
  // MARK: Properties Get/Set
  public func setExerciseLead(exerciseLead: Bool) {
    let manager: ModelManager = ModelManager.getInstance()!
    manager.setExerciseLead(modelType: self.modelType, exerciseLead: exerciseLead)
    self.exerciseLead = exerciseLead
  }
  
  public func setConfidenceScore(confidenceScore: Float) {
    self.confidenceScore = confidenceScore
    ModelManager.getInstance()!.removeConfidenceScore(observer: self)
  }
  
  public func reset() {
    self.detectedCount = 0
    self.frameInferenceCount = 0
    self.skippedFrameCount = 0
    self.locations.clear()
    self.infoBlobArrayList.clear()
  }
  
  func getModelType() -> ModelManager.MODELTYPE {
    return self.modelType
  }
  
  public func getAvgFrameDistance() -> Double {
    return self.avgFrameDistance
  }
  
  public func setMaxFps(fps: Int) {
    ModelManager.getInstance()!.setMaxFps(fps: fps, modelType: self.modelType)
  }
  
  public func inFrame() -> Bool {
    if self.id > 1033 { return true }
    return (self.getLocation()?.getStatus() ?? .MISSING) == .DETECTED
  }
  
  // MARK: Drawing Functions
  func draw(canvas: UIView) {
  }
  
  func drawDebug(canvas: UIView) {
    let location: DetectionLocation? = self.getDetectedLocation()
    if location == nil { return }
    if !location!.locationKnown() { return }
    let color = self.label.contains("RIGHT") ? UIColor.red : UIColor.blue
    DrawingManager.get().drawPoint(view: canvas, point: CGPoint(x: location!.getX(), y: location!.getY()), with: CGFloat(5.0), color: color)
  }
}
