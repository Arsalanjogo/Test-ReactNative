//
//  SensorManager.swift
//  jogo
//
//  Created by arham on 20/05/2021.
//

import Foundation
import CoreMotion
import RxRelay
import RxSwift


public class SensorManager: GyroDataFetcher, DeviceMotionProtocol, AccelerometerDataProtocol {
  // Singleton Static Sensor Manager
  // Allows management and provides an interface with the sensors
  // Current available sensors are
  // Gyro: Used for the Hidden Stop Button.
  // Motion: Used for Calibrating the device.
  // Acceleromenter: Not used. 18/06/2021
  
  public enum RotationPrompt: Int {
    case NONE = 0
    case LEFT = 1
    case RIGHT = 2
    case UP = 3
    case DOWN = 4
  }
  
  private static var sensorManager: SensorManager?
  private static var sensorManagerInstances = 0
  private var manager: CMMotionManager? // Only one instance of this class should be instantiated. Pass that by reference.
  
  private var gyro: Gyroscope?
  private var motionSensor: MotionSensor?
  private var accelerometerSensor: AccelerometerSensor?
  
  private var gyroData: UtilArrayList<CMGyroData> = UtilArrayList<CMGyroData>()
  private var motionData: UtilArrayList<CMDeviceMotion> = UtilArrayList<CMDeviceMotion>()
  private var accelerometerData: UtilArrayList<CMAccelerometerData> = UtilArrayList<CMAccelerometerData>()
  
  private let motionDataRelay: BehaviorRelay<CMDeviceMotion> = BehaviorRelay.init(value: CMDeviceMotion())

  public var angleColor: UIColor?
  public var rotationPromptVertical: RotationPrompt = .NONE
  public var rotationPromptHorizontal: RotationPrompt = .NONE
  
  public let motionDataObservable: Observable<CMDeviceMotion>
  
  // MARK: Lifecycle
  private init() {
    manager = CMMotionManager()
    motionDataObservable = motionDataRelay
      .asObservable()
      .skip(1)
  }
  
  public static func createInstance() -> SensorManager {
    if sensorManager == nil {
      sensorManager = SensorManager()
      sensorManagerInstances += 1
    }
    Logger.shared.log(logType: .ERROR, message: "Number of sensor manager instances are = \(SensorManager.sensorManagerInstances)")
    return sensorManager!
  }
  
  public static func getInstance() -> SensorManager? {
    return sensorManager
  }
  
  public static func removeInstance() {
    sensorManager = nil
    sensorManagerInstances -= 1
  }
  
  deinit {
    deinitalizeGyroscope()
    deinitializeMotionSensor()
    deinitializeAccelerometer()
    self.manager = nil
  }
  
  // MARK: Initialize specific sensors
  public func initialize(motion: Bool = false, accelerometer: Bool = false, gyro: Bool = false) {
    if motion { self.initializeMotion() }
    if accelerometer { self.initializeAccelerometer() }
    if gyro { self.initializeGyroscope() }
  }
  
  public func deinitialize(motion: Bool = true, accelerometer: Bool = true, gyro: Bool = true) {
    if motion { self.deinitializeMotionSensor() }
    if accelerometer { self.deinitializeAccelerometer() }
    if gyro { self.deinitalizeGyroscope() }
  }
  
  public func initializeGyroscope() {
    if gyro == nil {
      if !manager!.isGyroAvailable { return }
      gyro = Gyroscope(manager: manager!)
      gyro!.delegate = self
      gyro!.setUp()
    }
  }
  
  public func deinitalizeGyroscope() {
    if gyro != nil {
      gyro?.stop()
      gyro = nil
    }
  }
  
  public func initializeMotion() {
    if motionSensor == nil {
      if !manager!.isDeviceMotionAvailable { return }
      motionSensor = MotionSensor(manager: manager!)
      motionSensor!.delegate = self
      motionSensor!.setUp()
    }
  }
  
  public func deinitializeMotionSensor() {
    if motionSensor != nil {
      motionSensor?.stop()
      motionSensor = nil
    }
  }
  
  public func initializeAccelerometer() {
    if accelerometerSensor == nil {
      if !manager!.isAccelerometerAvailable { return }
      accelerometerSensor = AccelerometerSensor(manager: manager!)
      accelerometerSensor!.delegate = self
      accelerometerSensor!.setUp()
    }
  }
  
  public func deinitializeAccelerometer() {
    if accelerometerSensor != nil {
      accelerometerSensor?.stop()
      accelerometerSensor = nil
    }
  }
  
  // MARK: Protocols
  func onReceiveGyroData(data: CMGyroData) {
    _ = gyroData.add(value: data)
  }
  
  func onReceiveMotionData(data: CMDeviceMotion) {
    _ = motionData.add(value: data)
    motionDataRelay.accept(data)
  }
  
  func onReceiveAccelerometerData(data: CMAccelerometerData) {
    _ = accelerometerData.add(value: data)
  }
  
  // MARK: DataFetchers
  public func getMotionData() -> CMDeviceMotion? {
    if motionData.count() > 0 {
      do {
        return try motionData.getLast()
      } catch {
        Logger.shared.logError(logType: .ERROR, error: error)
        return nil
      }
    }
    return nil
  }
  
  public func getAccelerometerData() -> CMAccelerometerData? {
    if accelerometerData.count() > 0 {
      do {
        return try accelerometerData.getLast()
      } catch {
        Logger.shared.logError(logType: .ERROR, error: error)
        return nil
      }
    }
    return nil
  }
  
  public func getGyroData() -> CMGyroData? {
    if gyroData.count() > 0 {
      do {
        return try gyroData.getLast()
      } catch {
        Logger.shared.logError(logType: .ERROR, error: error)
        return nil
      }
    }
    return nil
  }
  
  public func getGyroData(n: Int = 0) -> CMGyroData? {
    if gyroData.count() > 0 && abs(n) < gyroData.count() {
      if n < 0 {
        return gyroData.get()[gyroData.count() + n]
      }
      return gyroData.get()[n]
      
    }
    return nil
  }
  
  
  // MARK: Logic for Calibration
  private func correctPlacement(rollAngle: Double, pitchAngle: Double) -> Bool {
    return rollAngle > motionSensor!.LANDSCAPE_ROLL_MIN &&
      rollAngle < motionSensor!.LANDSCAPE_ROLL_MAX  &&
      pitchAngle < motionSensor!.LANDSCAPE_PITCH_MAX &&
      pitchAngle > motionSensor!.LANDSCAPE_PITCH_MIN
    
  }
  
  public func isPlacedCorrectly() -> Bool {
    let data: CMDeviceMotion? = self.getMotionData()
    if data == nil { return false }
    let rollAngle: Double = abs(MathUtil.radianToDegrees(value: data!.attitude.roll))
    let pitchAngle: Double = abs(MathUtil.radianToDegrees(value: data!.attitude.pitch))
    let threshold_angle: Double = 30
    
    if correctPlacement(rollAngle: rollAngle, pitchAngle: pitchAngle) {
      angleColor = UIColor(red: 0, green: 1, blue: 0, alpha: 0)
      return true
    }
    let rollDistance: Double = min(abs(rollAngle - motionSensor!.LANDSCAPE_ROLL_MIN), abs(rollAngle - motionSensor!.LANDSCAPE_ROLL_MAX)) / threshold_angle
    let pitchDistance: Double = min(abs(pitchAngle - motionSensor!.LANDSCAPE_PITCH_MIN), abs(pitchAngle - motionSensor!.LANDSCAPE_PITCH_MAX)) / threshold_angle
    let distance: Double = min(sqrt(rollDistance * rollDistance + (pitchDistance * pitchDistance)), 1)
    angleColor = UIColor(red: CGFloat(distance), green: CGFloat(0), blue: CGFloat(0), alpha: 0.5)
    SpeechManager.get().talk(sentence: "Straighten your phone.")
    
    let pitchAngleRaw: Double = MathUtil.radianToDegrees(value: data!.attitude.pitch)
    
    if rollAngle < motionSensor!.LANDSCAPE_ROLL_MIN {
      rotationPromptVertical = .UP
    } else if rollAngle > motionSensor!.LANDSCAPE_ROLL_MAX {
      rotationPromptVertical = .DOWN
    } else {
      rotationPromptVertical = .NONE
    }
    
    if pitchAngleRaw < motionSensor!.LANDSCAPE_PITCH_MIN {
      rotationPromptHorizontal = .RIGHT
    } else if pitchAngleRaw > motionSensor!.LANDSCAPE_PITCH_MAX {
      rotationPromptHorizontal = .LEFT
    } else {
      rotationPromptHorizontal = .NONE
    }
    return false
  }
  
  // MARK: Logic for Stop Button
  public func isDeviceBeingHandled() -> Bool {
    let data: CMGyroData? = self.getGyroData()
    let datan1: CMGyroData? = self.getGyroData(n: -5)
    if data == nil || datan1 == nil { return false }
    let diffX: Double = datan1!.rotationRate.x - data!.rotationRate.x
    let diffY: Double = datan1!.rotationRate.y - data!.rotationRate.y
    let diffZ: Double = datan1!.rotationRate.z - data!.rotationRate.z
    if diffX > 0.1 || diffY > 0.1 || diffZ > 0.1 {
      return true
    }
    return false
  }
  
  // MARK: Drawing
  func drawMotion(canvas: UIView) {
  }
  
  func draw(canvas: UIView) {
    self.drawMotion(canvas: canvas)
  }
}
