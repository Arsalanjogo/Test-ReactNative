//
//  Posenet.swift
//  jogo
//
//  Created by arham on 22/02/2021.
//

import Foundation
import MLKitPoseDetectionAccurate
import MLKitVision

public let poseAccuracyThreshold: Float = 0.85

// https://developers.google.com/ml-kit/vision/pose-detection/ios
class Posenet: MLKitModel {
  // 32 keypoints detection model from Google's MLKit library.
  //
  internal var busy: Bool = false
  internal var detector: PoseDetector?
  
  internal var landmarkMap: [PoseLandmarkType: String] = [PoseLandmarkType: String]()
  
  fileprivate var processImage: Bool = true

  public init() {
    super.init(confidenceScore: poseAccuracyThreshold)
    setLandmarks()
  }
  
  public override func loadModel() {
    // Accurate pose detector graph specifically made for image streams aka videos.
    // Has the tracking module inside the graph.

    let options = AccuratePoseDetectorOptions()
    options.detectorMode = .stream
    detector = PoseDetector.poseDetector(options: options)
  }
  
  public override func preProcessImage(imageInfo: (esb: ExtendedSampleBuffer, ib: InfoBlob)) -> (image: VisionImage?, info: InfoBlob?) {
    // Convert the image to the appropriate MLKit type and set the orientation according to the documentation.
    // The orientation is extracted in the VideoCapture object.
    let image = VisionImage(buffer: imageInfo.esb.getSampleBuffer())
    image.orientation = imageInfo.esb.cameraOrientation!
    return (image, imageInfo.ib)
  }
  
  public func postProcessResults(landmark: PoseLandmark, orientation: UIImage.Orientation) -> CGPoint {
    // Get, scale and ?mirror the points for calculation and visualization.
    let x: CGFloat = (landmark.position.x) * CGFloat(ObjectDetectionState.xScale)
    let y: CGFloat = (landmark.position.y) * CGFloat(ObjectDetectionState.yScale)
    
    if orientation == .leftMirrored || orientation == .upMirrored || orientation == .downMirrored {
      return CGPoint(x: 1 - (x / ObjectDetectionState.screenSize.width), y: y / ObjectDetectionState.screenSize.height)
    }
    return CGPoint(x: x / ObjectDetectionState.screenSize.width, y: y / ObjectDetectionState.screenSize.height)
  }
  
  public override func runModel() {
    // Throttle and process the frames so no queue is formed.
    if processImage {
      processImage = false
    } else {
      processImage = true
      return
    }
    if busy || processed || !running { return }
    busy = true
    processed = true
    let sTime = Date().getNanoseconds()
    let infoBlob : InfoBlob = preProcessed.info!
    var results: [Pose]
    
    do {
      results = try detector!.results(in: preProcessed.image!)
    } catch let error {
      busy = false
      processed = false
      Logger.shared.logError(logType: .WARN, error: error, extraMsg: "Failed to detect pose with")
      return
    }
    
    guard !results.isEmpty else {
      busy = false
      processed = false
      return
    }
    let pose = results[0]

    // Convert the locations for distribution.
    var detectionLocation: [DetectionLocation] = [DetectionLocation]()
    for landmark in pose.landmarks {
      if landmark.inFrameLikelihood < confidenceScore! { continue }
      let label: String = landmarkMap[landmark.type]!
      let processedPoint = self.postProcessResults(landmark: landmark, orientation: preProcessed.image!.orientation)
      let point: PointLocation = PointLocation(classLabel: label,
                                               centerX: Double(processedPoint.x),
                                               centerY: Double(processedPoint.y),
                                               frameId: infoBlob.frameId!,
                                               confidence: Float(landmark.inFrameLikelihood),
                                               zValue: Double(landmark.position.z))
      detectionLocation.append(point)
    }
    busy = false
    do {
      Logger.shared.logFPSEveryNSeconds(msg: "Posenet FPS")
      try distributeLocations(argPair: (detectionLocation, infoBlob))
      
    } catch ModelErrors.frameRaceConditionAchieved {
      // Do something to fix this frame race condition error
      Logger.shared.logError(text: "Posenet Race Condition!")
    } catch {
      Logger.shared.logError(error: error)
    }
    Profiler.get().profileTime(frameId: infoBlob.frameId!, tag: "posenet", delta: Date().getNanoseconds() - sTime)
  }
  
  public override func stop() {
    super.stop()
  }
  
  internal func setLandmarks() {
    // Face
    landmarkMap[PoseLandmarkType.leftEye] = BODYPART.LEFT_EYE.rawValue
    landmarkMap[PoseLandmarkType.leftEyeInner] = BODYPART.LEFT_EYE_INNER.rawValue
    landmarkMap[PoseLandmarkType.leftEyeOuter] = BODYPART.LEFT_EYE_OUTER.rawValue
    landmarkMap[PoseLandmarkType.leftEar] = BODYPART.LEFT_EAR.rawValue
    landmarkMap[PoseLandmarkType.mouthLeft] = BODYPART.MOUTH_LEFT.rawValue

    landmarkMap[PoseLandmarkType.nose] = BODYPART.NOSE.rawValue

    landmarkMap[PoseLandmarkType.rightEye] = BODYPART.RIGHT_EYE.rawValue
    landmarkMap[PoseLandmarkType.rightEyeInner] = BODYPART.RIGHT_EYE_INNER.rawValue
    landmarkMap[PoseLandmarkType.rightEyeOuter] = BODYPART.RIGHT_EYE_OUTER.rawValue
    landmarkMap[PoseLandmarkType.rightEar] = BODYPART.RIGHT_EAR.rawValue
    landmarkMap[PoseLandmarkType.mouthRight] = BODYPART.MOUTH_RIGHT.rawValue

    // Torso
    landmarkMap[PoseLandmarkType.leftShoulder] = BODYPART.LEFT_SHOULDER.rawValue
    landmarkMap[PoseLandmarkType.leftHip] = BODYPART.LEFT_HIP.rawValue
    landmarkMap[PoseLandmarkType.rightShoulder] = BODYPART.RIGHT_SHOULDER.rawValue
    landmarkMap[PoseLandmarkType.rightHip] = BODYPART.RIGHT_HIP.rawValue

    // Hands
    landmarkMap[PoseLandmarkType.leftElbow] = BODYPART.LEFT_ELBOW.rawValue
    landmarkMap[PoseLandmarkType.leftIndexFinger] = BODYPART.LEFT_INDEX_FINGER.rawValue
    landmarkMap[PoseLandmarkType.leftPinkyFinger] = BODYPART.LEFT_PINKY_FINGER.rawValue
    landmarkMap[PoseLandmarkType.leftThumb] = BODYPART.LEFT_THUMB.rawValue
    landmarkMap[PoseLandmarkType.leftWrist] = BODYPART.LEFT_WRIST.rawValue

    landmarkMap[PoseLandmarkType.rightElbow] = BODYPART.RIGHT_ELBOW.rawValue
    landmarkMap[PoseLandmarkType.rightIndexFinger] = BODYPART.RIGHT_INDEX_FINGER.rawValue
    landmarkMap[PoseLandmarkType.rightPinkyFinger] = BODYPART.RIGHT_PINKY_FINGER.rawValue
    landmarkMap[PoseLandmarkType.rightThumb] = BODYPART.RIGHT_THUMB.rawValue
    landmarkMap[PoseLandmarkType.rightWrist] = BODYPART.RIGHT_WRIST.rawValue

    // Legs
    landmarkMap[PoseLandmarkType.leftKnee] = BODYPART.LEFT_KNEE.rawValue
    landmarkMap[PoseLandmarkType.leftAnkle] = BODYPART.LEFT_ANKLE.rawValue
    landmarkMap[PoseLandmarkType.leftHeel] = BODYPART.LEFT_HEEL.rawValue
    landmarkMap[PoseLandmarkType.leftToe] = BODYPART.LEFT_TOE.rawValue

    landmarkMap[PoseLandmarkType.rightKnee] = BODYPART.RIGHT_KNEE.rawValue
    landmarkMap[PoseLandmarkType.rightAnkle] = BODYPART.RIGHT_ANKLE.rawValue
    landmarkMap[PoseLandmarkType.rightHeel] = BODYPART.RIGHT_HEEL.rawValue
    landmarkMap[PoseLandmarkType.rightToe] = BODYPART.RIGHT_TOE.rawValue
    
  }
  
  public enum BODYPART: String {
    case LEFT_EYE
    case LEFT_EYE_INNER
    case LEFT_EYE_OUTER
    case LEFT_EAR
    case MOUTH_LEFT
    
    case NOSE
    
    case RIGHT_EYE
    case RIGHT_EYE_INNER
    case RIGHT_EYE_OUTER
    case RIGHT_EAR
    case MOUTH_RIGHT
    
    case LEFT_SHOULDER
    case LEFT_HIP
    case RIGHT_SHOULDER
    case RIGHT_HIP
    
    case LEFT_ELBOW
    case LEFT_INDEX_FINGER
    case LEFT_PINKY_FINGER
    case LEFT_THUMB
    case LEFT_WRIST
    
    case RIGHT_ELBOW
    case RIGHT_INDEX_FINGER
    case RIGHT_PINKY_FINGER
    case RIGHT_THUMB
    case RIGHT_WRIST
    
    case LEFT_KNEE
    case LEFT_ANKLE
    case LEFT_HEEL
    case LEFT_TOE
    
    case RIGHT_KNEE
    case RIGHT_ANKLE
    case RIGHT_HEEL
    case RIGHT_TOE
  }
  
  // These IDs are used for mapping and comparing observers.
  public enum ObserverID: Int {
    case LEFT_EYE = 1001
    case LEFT_EYE_INNER = 1002
    case LEFT_EYE_OUTER = 1003
    case LEFT_EAR = 1004
    case MOUTH_LEFT = 1005
    
    case NOSE = 1006
    
    case RIGHT_EYE = 1007
    case RIGHT_EYE_INNER = 1008
    case RIGHT_EYE_OUTER = 1009
    case RIGHT_EAR = 1010
    case MOUTH_RIGHT = 1011
    
    case LEFT_SHOULDER = 1012
    case LEFT_HIP = 1013
    case RIGHT_SHOULDER = 1014
    case RIGHT_HIP = 1015
    
    case LEFT_ELBOW = 1016
    case LEFT_INDEX_FINGER = 1017
    case LEFT_PINKY_FINGER = 1018
    case LEFT_THUMB = 1019
    case LEFT_WRIST = 1020
    
    case RIGHT_ELBOW = 1021
    case RIGHT_INDEX_FINGER = 1022
    case RIGHT_PINKY_FINGER = 1023
    case RIGHT_THUMB = 1024
    case RIGHT_WRIST = 1025
    
    case LEFT_KNEE = 1026
    case LEFT_ANKLE = 1027
    case LEFT_HEEL = 1028
    case LEFT_TOE = 1029
    
    case RIGHT_KNEE = 1030
    case RIGHT_ANKLE = 1031
    case RIGHT_HEEL = 1032
    case RIGHT_TOE = 1033
    
    case LEFT_ARM = 1034
    case RIGHT_ARM = 1035
    case FACE = 1036
    case LEFT_LEG = 1037
    case RIGHT_LEG = 1038
    case TORSO = 1039
    case PERSON = 1040
  }
}
