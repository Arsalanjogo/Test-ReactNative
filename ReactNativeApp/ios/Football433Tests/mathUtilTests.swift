//
//  mathUtilTests.swift
//  jogoTests
//
//  Created by arham on 13/09/2021.
//

import XCTest

@testable import Football433

class MathUtilTests: XCTestCase {
  
  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    try super.setUpWithError()
  }
  
  override func tearDownWithError() throws {
    try super.tearDownWithError()
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  // MathDistance Tests.
  
  func testEuclideanDistanceLogicComparison() throws {
    for xcoord in stride(from: -10, to: 10, by: 0.1) {
      for ycoord in stride(from: -10, to: 10, by: 0.1) {
        let det1 = DetectionLocation(label: "__", centerX: xcoord, centerY: ycoord, frameId: 1, confidence: 0.9, status: .DETECTED)
        let det2 = DetectionLocation(label: "____", centerX: 1 - xcoord, centerY: 1 - ycoord, frameId: 1, confidence: 0.9, status: .DETECTED)
        let d1: Double = det1.getEuclideanDistance(location: det2)
        let d2: Double = MathUtil.getDistance(a: det1, b: det2)
        XCTAssertEqual(d1.n_dp(dp: 4), d2.n_dp(dp: 4), "Distance logic giving different answers??")
      }
    }
  }
  
  func testEuclideanDistanceLogicDouble() throws {
    for xcoord in stride(from: -10, to: 10, by: 0.1) {
      for ycoord in stride(from: -10, to: 10, by: 0.1) {
        let d1: Double = MathUtil.getDistance(x1: xcoord, y1: ycoord, x2: 1 - xcoord, y2: 1 - ycoord)
        let d2: Double = sqrt(pow(abs(xcoord - (1 - xcoord)), 2) + pow(abs(ycoord - (1-ycoord)), 2))
        XCTAssertEqual(d1.n_dp(dp: 4), d2.n_dp(dp: 4), "Distance logic giving different answers??")
      }
    }
  }
  
  func testEuclideanDistanceLogicDetLocation() throws {
    for xcoord in stride(from: -10, to: 10, by: 0.1) {
      for ycoord in stride(from: -10, to: 10, by: 0.1) {
        let det1 = DetectionLocation(label: "__", centerX: xcoord, centerY: ycoord, frameId: 1, confidence: 0.9, status: .DETECTED)
        let det2 = DetectionLocation(label: "____", centerX: 1 - xcoord, centerY: 1 - ycoord, frameId: 1, confidence: 0.9, status: .DETECTED)
        let d1: Double = MathUtil.getDistance(a: det1, b: det2)
        let d2: Double = sqrt(pow(abs(xcoord - (1 - xcoord)), 2) + pow(abs(ycoord - (1-ycoord)), 2))
        XCTAssertEqual(d1.n_dp(dp: 4), d2.n_dp(dp: 4), "Distance logic giving different answers??")
      }
    }
  }
  
  func testEuclideanDistanceLogicObjectDetection() throws {
    let obj1: ObjectDetection = ObjectDetection(label: "Test1", modelType: .SKIP, exerciseLead: false, observerId: 1, testing: true)
    let obj2: ObjectDetection = ObjectDetection(label: "Test2", modelType: .SKIP, exerciseLead: false, observerId: 2, testing: true)
    var frameId: Int = 1
    for xcoord in stride(from: -10, to: 10, by: 0.1) {
      for ycoord in stride(from: -10, to: 10, by: 0.1) {
        frameId += 1
        let infoBlob: InfoBlob = InfoBlob(frameId: frameId)
        let dets: [DetectionLocation] = [
          DetectionLocation(label: "Test1", centerX: xcoord, centerY: ycoord, frameId: 1, confidence: 0.9, status: .DETECTED),
          DetectionLocation(label: "Test2", centerX: 1 - xcoord, centerY: 1 - ycoord, frameId: 1, confidence: 0.9, status: .DETECTED)]
        obj1.parse(detectedLocations: dets, infoBlob: infoBlob)
        let d1: Double = MathUtil.getDistance(a: obj1, b: obj2)
        let d2: Double = sqrt(pow(abs(xcoord - (1 - xcoord)), 2) + pow(abs(ycoord - (1-ycoord)), 2))
        XCTAssertEqual(d1.n_dp(dp: 4), d2.n_dp(dp: 4), "Distance logic giving different answers??")
      }
    }
  }
  
  
  // MathAngle Tests
  
  struct AngleDataPoint {
    var p1: Double
    var p2: Double
    var p3: Double
    var p4: Double
    var p5: Double
    var p6: Double
    var dA: Double
    var dB: Double
    var dC: Double
    var answer: Double
  }
  
  func testAngleCalculation() throws {
    
    let points: [AngleDataPoint] = [
      AngleDataPoint(p1: 0.1, p2: 0.1, p3: 0.9, p4: 0.9, p5: 0.1, p6: 0.9, dA: 0.8, dB: 1.13137, dC: 0.8, answer: 45),
      AngleDataPoint(p1: 0.1, p2: 0.4,
                     p3: 0.9, p4: 0.9,
                     p5: 0.6, p6: 0.6,
                     dA: 0.424264,
                     dB: 0.538516,
                     dC: 0.943398,
                     answer: 13),
    ]
    for datapoint in points {
      let d1: DetectionLocation = DetectionLocation(label: "1", centerX: datapoint.p1, centerY: datapoint.p2, frameId: 1, confidence: 0.9, status: .DETECTED)
      let d2: DetectionLocation = DetectionLocation(label: "2", centerX: datapoint.p3, centerY: datapoint.p4, frameId: 1, confidence: 0.9, status: .DETECTED)
      let d3: DetectionLocation = DetectionLocation(label: "3", centerX: datapoint.p5, centerY: datapoint.p6, frameId: 1, confidence: 0.9, status: .DETECTED)
      let angle: Double = MathUtil.calculateAngle3Points(pA: d1, pB: d2, pC: d3, negativeAngle: false)
      XCTAssertEqual(angle, datapoint.answer)
    }
  }
  
  
  // MathMean Tests.
  
  struct MeanDataPoint {
    var p1: (Double, Double, Double)
    var p2: (Double, Double, Double)
    var answers: [Double]
  }
  
  let meanPoints: [MeanDataPoint] = [
    MeanDataPoint(p1: (0.23, 0.11, 0.933), p2: (0.1, 0.2, 0.3), answers: [0.165, 0.155, 0.6165]),
    MeanDataPoint(p1: (-0.23, -0.11, -0.933), p2: (0.1, 0.2, 0.3), answers: [-0.065, 0.045, -0.3165]),
    MeanDataPoint(p1: (-10000, -100000000000000, 100000000000000), p2: (0.1111111111, 0.111111111111, 0.99999999999), answers: [-4999.94444444445, -49999999999999.945, 50000000000000.5]),
  ]
  
  func testMeanDouble() throws {
    
    for datapoint in meanPoints {
      let mx = MathUtil.getMean(a: datapoint.p1.0, b: datapoint.p2.0)
      let my = MathUtil.getMean(a: datapoint.p1.1, b: datapoint.p2.1)
      let mz = MathUtil.getMean(a: datapoint.p1.2, b: datapoint.p2.2)
      XCTAssertEqual(mx.n_dp(dp: 3), datapoint.answers[0].n_dp(dp: 3))
      XCTAssertEqual(my.n_dp(dp: 3), datapoint.answers[1].n_dp(dp: 3))
      XCTAssertEqual(mz.n_dp(dp: 3), datapoint.answers[2].n_dp(dp: 3))
    }
  }
  
  func testMeanDetLocation() throws {
    
    for datapoint in meanPoints {
      let d1: DetectionLocation = PointLocation(classLabel: "Test1", centerX: datapoint.p1.0, centerY: datapoint.p1.1, frameId: 1, confidence: 0.9, status: .DETECTED, radius: 0.1, zValue: datapoint.p1.2)
      let d2: DetectionLocation = PointLocation(classLabel: "Test2", centerX: datapoint.p2.0, centerY: datapoint.p2.1, frameId: 1, confidence: 0.9, status: .DETECTED, radius: 0.1, zValue: datapoint.p2.2)
      let mx = MathUtil.getMean(a: d1, b: d2, axis: .x)
      let my = MathUtil.getMean(a: d1, b: d2, axis: .y)
      let mz = MathUtil.getMean(a: d1, b: d2, axis: .z)
      XCTAssertEqual(mx.n_dp(dp: 3), datapoint.answers[0].n_dp(dp: 3))
      XCTAssertEqual(my.n_dp(dp: 3), datapoint.answers[1].n_dp(dp: 3))
      XCTAssertEqual(mz.n_dp(dp: 3), datapoint.answers[2].n_dp(dp: 3))
    }
  }
  
  // MathClip Tests.
  
  struct ClipDataPoint {
    var radius: Double
    var inside: Double
    var answer: Double
  }
  
  func testClip() throws {
    let points: [ClipDataPoint] = [
      ClipDataPoint(radius: 0.2, inside: 0.6, answer: 0.6),
      ClipDataPoint(radius: 0.1, inside: 0.05, answer: 0.1)
    ]
  }
  
  
  // MathUtil Tests.
  
  struct AngleConversionPoint {
    var value: Double
    var answer: Double
  }
  
  func testRadiansToDegrees() throws {
    let points: [AngleConversionPoint] = [
      AngleConversionPoint(value: 0, answer: 0),
      AngleConversionPoint(value: 1, answer: 57.2958),
      AngleConversionPoint(value: 2, answer: 114.592),
      AngleConversionPoint(value: 0.785398, answer: 45),
      AngleConversionPoint(value: 3.14159, answer: 180),
      AngleConversionPoint(value: 1.5708, answer: 90),
      AngleConversionPoint(value: 0.3926991, answer: 22.5),
      AngleConversionPoint(value: -1.5708, answer: -90),
      AngleConversionPoint(value: -3.14159, answer: -180),
    ]
    
    for datapoint in points {
      let degreeAngle: Double = MathUtil.radianToDegrees(value: datapoint.value)
      XCTAssertEqual(degreeAngle, datapoint.answer)
    }
  }
  
  func testDegreeToRadians() throws {
    let points: [AngleConversionPoint] = [
      AngleConversionPoint(value: 0, answer: 0),
      AngleConversionPoint(value: 57.2958, answer: 1),
      AngleConversionPoint(value: 114.592, answer: 2),
      AngleConversionPoint(value: 45, answer: 0.785398),
      AngleConversionPoint(value: 180, answer: 3.14159),
      AngleConversionPoint(value: 90, answer: 1.5708),
      AngleConversionPoint(value: 22.5, answer: 0.3926991),
      AngleConversionPoint(value: -90, answer: -1.5708),
      AngleConversionPoint(value: -180, answer: -3.14159),
    ]
    
    for datapoint in points {
      let degreeAngle: Double = MathUtil.degreesToRadian(value: datapoint.value)
      XCTAssertEqual(degreeAngle.n_dp(dp: 3), datapoint.answer.n_dp(dp: 3))
    }
  }
}
