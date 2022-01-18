//
//  PersonDetection.swift
//  jogo
//
//  Created by arham on 14/03/2021.
//

import Foundation

class PersonDetection: ObjectDetection {
  
  public enum LyingDirection: String {
    case LEFT2RIGHT = "Left2Right"
    case RIGHT2LEFT = "Right2Left"
  }
  
  public enum LyingDownFacingDirection: String {
    case UP = "Up"
    case DOWN = "Down"
  }
  
  static var shared: PersonDetection?
  
  // Person Detection, uses variables which are MLKit Posenet specific.
  public final var face: FaceDetection?
  public final var leftArm: ArmDetection?
  public final var rightArm: ArmDetection?
  public final var leftLeg: LegDetection?
  public final var rightLeg: LegDetection?
  public final var shoulderToShoulder, rightShoulderRightHip, leftShoulderLeftHip, hipToHip: Bone?
  
  public var up: Bool = true
  
  var bodyParts: [BodyPartDetection] = [BodyPartDetection]()
  var bones: [Bone] = [Bone]()
  
  public var highestLeftAnkle, highestRightAnkle, lowestLeftHeel, lowestRightHeel, lowestHighLeftHeel, lowestHighRightHeel: DetectionLocation?
  
  let JUMP_LOOKBACK: Int = 30
  let GROUND_LOOKBACK: Int = 6
  let HEAD_LOOKBACK: Int = 6
  public let MIN_JUMP: Double = 0.08
  public let MIN_JUMP_FRAME_DISTANCE: Int = 5
  private var associatedLabels: Set<String>?
  private var objectDetectionSet: Set<ObjectDetection>?
  private var groundLine: Double = 0
  
  // MARK: Lifecycle
  init(exerciseLead: Bool = false, modelType: ModelManager.MODELTYPE, upperBody: Bool = true, lowerBody: Bool = true) {
    super.init(label: "Person", modelType: modelType, exerciseLead: exerciseLead, observerId: Posenet.ObserverID.PERSON.rawValue)
    
    // UpperBodyOnly
    if !upperBody && !lowerBody {
      return
    }
    if upperBody {
      face = FaceDetection(exerciseLead: exerciseLead, person: self, modelType: modelType)
      leftArm = ArmDetection(orientation: ArmDetection.Orientation.LEFT, exerciseLead: exerciseLead, person: self, modelType: modelType)
      rightArm = ArmDetection(orientation: ArmDetection.Orientation.RIGHT, exerciseLead: exerciseLead, person: self, modelType: modelType)
      bodyParts.append(face!)
      bodyParts.append(leftArm!)
      bodyParts.append(rightArm!)
      shoulderToShoulder = Bone(bodyElement1: leftArm!.shoulder, bodyElement2: rightArm!.shoulder)
      bones.append(shoulderToShoulder!)
    }
    if lowerBody {
      leftLeg = LegDetection(orientation: LegDetection.Orientation.LEFT, exerciseLead: exerciseLead, person: self, modelType: modelType)
      rightLeg = LegDetection(orientation: LegDetection.Orientation.RIGHT, exerciseLead: exerciseLead, person: self, modelType: modelType)
      bodyParts.append(leftLeg!)
      bodyParts.append(rightLeg!)
      hipToHip = Bone(bodyElement1: leftLeg!.hip, bodyElement2: rightLeg!.hip)
      bones.append(hipToHip!)
    }
    if upperBody && lowerBody {
      rightShoulderRightHip = Bone(bodyElement1: rightArm!.shoulder, bodyElement2: rightLeg!.hip)
      leftShoulderLeftHip = Bone(bodyElement1: leftArm!.shoulder, bodyElement2: leftLeg!.hip)
      bones.append(rightShoulderRightHip!)
      bones.append(leftShoulderLeftHip!)
    }
    PersonDetection.shared = self
  }
  
  public override func parse(detectedLocations: [DetectionLocation], infoBlob: InfoBlob) {
    super.parse(detectedLocations: detectedLocations, infoBlob: infoBlob)
    bones.forEach { (bone) in
      bone.updateLength()
    }
  }
  
  public override func unsubscribe() {
    super.unsubscribe()
    bodyParts.forEach { (bdyPart) in
      bdyPart.unsubscribe()
    }
  }
  
  public override func reset() {
    super.reset()
    bodyParts.forEach { bdyPart in
      bdyPart.reset()
    }
  }
  
  // MARK: Properties Get/Set
  
  public func getAssociatedLabels() -> Set<String> {
    if associatedLabels == nil {
      associatedLabels = Set<String>()
      bodyParts.forEach { (bdyPart) in
        let labels: Set<String> = bdyPart.getAssociatedLabels()
        associatedLabels = associatedLabels!.union(labels)
      }
    }
    return associatedLabels!
  }
  
  public func getDetectionSubClasses() -> Set<ObjectDetection> {
    if objectDetectionSet == nil {
      objectDetectionSet = Set<ObjectDetection>()
      bodyParts.forEach { (bdyPart) in
        let detSet: Set<ObjectDetection> = bdyPart.getObjectDetections()
        objectDetectionSet = objectDetectionSet?.union(detSet)
      }
    }
    return objectDetectionSet!
  }
  
  public override func setConfidenceScore(confidenceScore: Float) {
    super.setConfidenceScore(confidenceScore: confidenceScore)
    bodyParts.forEach { (bdyPart) in
      bdyPart.setConfidenceScore(confidenceScore: confidenceScore)
    }
  }
  
  // MARK: Calculate Properties
  public func getCenterPoint() -> (Double, Double)? {
    let leftHip: DetectionLocation? = leftLeg!.hip.getDetectedLocation()
    let leftShoulder: DetectionLocation? = leftArm!.shoulder.getDetectedLocation()
    let rightHip: DetectionLocation? = rightLeg!.hip.getDetectedLocation()
    let rightShoulder: DetectionLocation? = rightArm!.shoulder.getDetectedLocation()
    if leftHip == nil || leftShoulder == nil || rightHip == nil || rightShoulder == nil {
      return nil
    }
    return ((leftHip!.getX() + leftShoulder!.getX() + rightHip!.getX() + rightShoulder!.getX()) / 4.0,
            (leftHip!.getY() + leftShoulder!.getY() + rightHip!.getY() + rightShoulder!.getY()) / 4.0)
  }
  
  public func didJump(lastJumpFrameId: Int) -> Int {
    if getInfoBlobArrayList().count() < JUMP_LOOKBACK { return 0 }
    var lastFrameId: Int
    do {
      lastFrameId = try getInfoBlobArrayList().getLast()!.frameId!
    } catch {
      Logger.shared.logError(logType: .ERROR, error: error)
      return 0 }
    
    let leftHeels = leftLeg!.heel.getNDetectionLocations(locationCount: min(JUMP_LOOKBACK, lastFrameId - lastJumpFrameId))
    let rightHeels = rightLeg!.heel.getNDetectionLocations(locationCount: min(JUMP_LOOKBACK, lastFrameId - lastJumpFrameId))
    
    if leftHeels == nil || rightHeels == nil {
      return 0 }
    if leftHeels!.isEmpty() || rightHeels!.isEmpty() {
      return 0 }
    
    lowestLeftHeel = leftHeels!.getMin(comparator: { (det1, det2) -> Bool in
      det1.getY() < det2.getY()
    })
    lowestRightHeel = rightHeels!.getMin(comparator: { (det1, det2) -> Bool in
      det1.getY() < det2.getY()
    })
    let leftHighIndex: Int = leftHeels!.get().firstIndex { (detLoc) -> Bool in
      detLoc.frameId == lowestLeftHeel!.frameId
    }!
    let rightHighIndex: Int = rightHeels!.get().firstIndex { (detLoc) -> Bool in
      detLoc.frameId == lowestRightHeel!.frameId
    }!
    
    let leftAnkles = leftHeels?.get()[0 ..< leftHighIndex]
    let rightAnkles = rightHeels?.get()[0 ..< rightHighIndex]
    if leftAnkles == nil || rightAnkles == nil {
      return 0 }
    if leftAnkles!.isEmpty || rightAnkles!.isEmpty {
      return 0 }
    highestLeftAnkle = leftAnkles!.max(by: { (det1, det2) -> Bool in
      det1.getY() < det2.getY()
    })
    highestRightAnkle = rightAnkles!.max(by: { (det1, det2) -> Bool in
      det1.getY() < det2.getY()
    })
    
    let leftHighHeels = leftHeels?.get()[leftHighIndex + 1 ..< (leftHeels?.count())!]
    let rightHighHeels = rightHeels?.get()[rightHighIndex + 1 ..< (rightHeels?.count())!]
    if leftHighHeels == nil || rightHighHeels == nil {
      return 0 }
    lowestHighLeftHeel = leftHighHeels!.max(by: { (det1, det2) -> Bool in
      det1.getY() < det2.getY()
    })
    lowestHighRightHeel = rightHighHeels!.max(by: { (det1, det2) -> Bool in
      det1.getY() < det2.getY()
    })
    
    if lowestLeftHeel == nil || lowestRightHeel == nil || lowestHighLeftHeel == nil || lowestHighRightHeel == nil {
      return 0
    }
    
    if jumpConditionOne() {
      if (max(lowestHighLeftHeel!.getFrameId(), lowestHighRightHeel!.getFrameId()) - lastJumpFrameId) <= MIN_JUMP_FRAME_DISTANCE {
        return lastJumpFrameId
      } else {
        return max(lowestLeftHeel!.getFrameId(), lowestRightHeel!.getFrameId())
      }
    }
    return lastJumpFrameId
  }
  
  func jumpConditionOne() -> Bool {
    return (lowestLeftHeel!.getY() + MIN_JUMP) < highestLeftAnkle!.getY() &&
              (lowestRightHeel!.getY() + MIN_JUMP) < highestRightAnkle!.getY() &&
              (lowestHighLeftHeel!.getY() - MIN_JUMP) > lowestLeftHeel!.getY() &&
              (lowestHighRightHeel!.getY() - MIN_JUMP) > lowestRightHeel!.getY()
  }
  
  public func getGroundLine() -> Double {
    let leftAnkleLocations: UtilArrayList<DetectionLocation>? = leftLeg!.ankle.getNDetectionLocations(locationCount: GROUND_LOOKBACK)
    let rightAnkleLocations: UtilArrayList<DetectionLocation>? = rightLeg!.ankle.getNDetectionLocations(locationCount: GROUND_LOOKBACK)
    if leftAnkleLocations == nil || rightAnkleLocations == nil { return groundLine }
    let highLeft: Double = leftAnkleLocations!.getMax(comparator: { (det1, det2) -> Bool in
      det1.getY() < det2.getY()
    })!.getY()
    
    let highRight: Double = rightAnkleLocations!.getMax { (det1, det2) -> Bool in
      det1.getY() < det2.getY()
    }!.getY()
    groundLine = max(highLeft, highRight)
    return groundLine
  }
  
  public func getHeadLine() -> Double {
    let leftEyeLocations: UtilArrayList<DetectionLocation>? = face!.leftEye.getNDetectionLocations(locationCount: GROUND_LOOKBACK)
    let rightEyeLocations: UtilArrayList<DetectionLocation>? = face!.rightEye.getNDetectionLocations(locationCount: GROUND_LOOKBACK)
    if leftEyeLocations == nil || rightEyeLocations == nil { return -1 }
    let highLeft: Double = leftEyeLocations!.getMin(comparator: { (det1, det2) -> Bool in
      det1.getY() < det2.getY()
    })!.getY()
    
    let highRight: Double = rightEyeLocations!.getMin { (det1, det2) -> Bool in
      det1.getY() < det2.getY()
    }!.getY()
    return max(highLeft, highRight)
  }
  
  public func isPersonLayingDown() -> Bool {
    let faceX: Double? = face!.nose.getX()
    let shoulderX: Double? = (leftArm!.shoulder.getY() ?? -1) < (rightArm!.shoulder.getY() ?? 1) ? leftArm!.shoulder.getX() : rightArm!.shoulder.getX()
    let hipX: Double? = (leftLeg!.hip.getY() ?? -1) < (rightLeg!.hip.getY() ?? 1) ? leftLeg!.hip.getX() : rightLeg!.hip.getX()
    if shoulderX == nil || hipX == nil || faceX == nil { return false }
    
    if faceX! < shoulderX! && shoulderX! < hipX! {
      return true
    }
    if faceX! > shoulderX! && shoulderX! > hipX! {
      return true
    }
    return false
  }
  
  public func isPersonStanding() -> Bool {
    let standingThreshold: Double = 0.04
    var shoulder: DetectionLocation?
    var hip: DetectionLocation?
    if (leftArm!.shoulder.getY() ?? -1) < (rightArm!.shoulder.getY() ?? 1) {
      shoulder = leftArm!.shoulder.getDetectedLocation()
      hip = leftLeg!.hip.getDetectedLocation()
    } else {
      shoulder = rightArm!.shoulder.getDetectedLocation()
      hip = rightLeg!.hip.getDetectedLocation()
    }
    if shoulder == nil || hip == nil { return false }
    let xDiff: Double = abs(shoulder!.getX() - hip!.getX())
    let yDiff: Double = abs(shoulder!.getY() - hip!.getY())
    if yDiff - xDiff > standingThreshold { return true }
    return false
  }
  
  public func isPersonLayingFlat() -> Bool {
    let highestHip: DetectionLocation? = (leftLeg!.hip.getY() ?? -1) < (rightLeg!.hip.getY() ?? 1) ? leftLeg!.hip.getDetectedLocation() : rightLeg!.hip.getDetectedLocation()
    let highestShoulder: DetectionLocation? = (leftArm!.shoulder.getY() ?? -1) < (rightArm!.shoulder.getY() ?? 1) ?
      leftArm!.shoulder.getDetectedLocation() : rightArm!.shoulder.getDetectedLocation()
    let lowestShoulder: DetectionLocation? = (leftArm!.shoulder.getY() ?? -1) > (rightArm!.shoulder.getY() ?? 1) ?
      leftArm!.shoulder.getDetectedLocation() : rightArm!.shoulder.getDetectedLocation()
    
    if highestHip == nil || highestShoulder == nil || lowestShoulder == nil { return false }
    
    let shoulderDistance: Double = highestShoulder!.getEuclideanDistance(location: lowestShoulder!)
    let hipShoulderDistance: Double = highestHip!.getEuclideanDistance(location: highestShoulder!)
    
    if shoulderDistance >= (hipShoulderDistance / 2.0) { return true }
    return false
  }
  
  public func getPersonLyingDirection() -> LyingDirection {
    if (self.leftArm!.shoulder.getX() ?? 0) < (self.leftLeg!.hip.getX() ?? 1) &&
        (self.leftLeg!.hip.getX() ?? 0) < (self.leftLeg!.heel.getX() ?? 1) {
      return LyingDirection.LEFT2RIGHT
    }
    return LyingDirection.RIGHT2LEFT
  }
  
  public func getPersonLyingDownFacingDirection() -> LyingDownFacingDirection {
    
    if (leftArm!.shoulder.getY() ?? 0) < (leftArm!.wrist.getY() ?? 1) {
      return .DOWN
    }
    return .UP
  }
  
  public func getPersonArmLength() -> Double {
    let shoulderLocation: DetectionLocation? = leftArm?.shoulder.getLocation()
    let wristLocation: DetectionLocation? = leftArm?.wrist.getLocation()
    if wristLocation == nil { return 0.25 }
    if shoulderLocation == nil { return 0.25 }
    let distance: Double = MathUtil.getDistance(a: shoulderLocation!, b: wristLocation!)
    return distance
  }
  
  override func inFrame() -> Bool {
    var val: Bool = super.inFrame()
    self.bodyParts.forEach { bdyPart in
      val = val && bdyPart.inFrame()
    }
    return val
  }

  // MARK: Draw functionality
  public override func draw(canvas: UIView) {
    super.draw(canvas: canvas)
    bones.forEach { (bone) in
      bone.draw(canvas: canvas)
    }
    bodyParts.forEach { (bodyPart) in
      bodyPart.draw(canvas: canvas)
    }
  }
  
  public func drawBBox(canvas: UIView) {
    let lastLocations = self.getDetectionSubClasses().filter { d in
      return d.getLocation() != nil && d.getLocation()!.getStatus() == .DETECTED
    }
    guard !lastLocations.isEmpty else { return }
    let minX = lastLocations.min { d1, d2 in
      return d1.getX()! < d2.getX()!
    }?.getX()
    let minY = lastLocations.min { d1, d2 in
      return d1.getY()! < d2.getY()!
    }?.getY()
    let maxX = lastLocations.max { d1, d2 in
      return d1.getX()! < d2.getX()!
    }?.getX()
    let maxY = lastLocations.max { d1, d2 in
      return d1.getY()! < d2.getY()!
    }?.getY()
    let width = 1.4 * (maxX!-minX!)
    DrawingManager.get().drawHollowRect(view: canvas,
                                         rect: CGRect(x: minX! - (0.2 * width), y: minY!, width: width, height: maxY! - minY!),
                                         color: ThemeManager.shared.theme.primaryColor.withAlphaComponent(0.6),
                                         borderWidth: 5.0)
  }
  
  public override func drawDebug(canvas: UIView) {
    super.drawDebug(canvas: canvas)
    bones.forEach { (bone) in
      bone.drawDebug(canvas: canvas)
    }
    bodyParts.forEach { (bodyPart) in
      bodyPart.drawDebug(canvas: canvas)
    }
  }
  
  public static func getInstance() -> PersonDetection {
    if PersonDetection.shared == nil {
      PersonDetection.shared = PersonDetection(exerciseLead: false, modelType: .POSENET, upperBody: true, lowerBody: true)
    }
    return PersonDetection.shared!
  }
  
}
