//
//  locationTests.swift
//  jogoTests
//
//  Created by Muhammad Nauman on 23/11/2021.
//

import XCTest
@testable import Football433

class locationTests: XCTestCase {
  
  var locations: [Location]?
  var uiView: UIView!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
      try super.setUpWithError()
      if let locs: [Location] = JSONReader.shared.getObject(from: "tests/location.json") {
        locations = locs
        uiView = UIView(frame: .zero)
        print(locations)
      } else {
        print("Something went wrong!")
        throw TestError.JSONFileError
      }
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
      try super.tearDownWithError()
    }

    func testLocationInScreen() throws {
      for location in locations! {
        XCTAssertGreaterThanOrEqual(location.getX(), 0)
        XCTAssertGreaterThanOrEqual(location.getY(), 0)
        XCTAssertLessThanOrEqual(location.getX(), UIScreen.main.bounds.width)
        XCTAssertLessThanOrEqual(location.getY(), UIScreen.main.bounds.height)
      }
    }
  
  func testEuclideanDistance() throws {
    XCTAssertEqual(locations![0].getEuclideanDistance(location: locations![1]), 5.0)
  }
  
  func testIntersection() throws {
    let locusCenter = Location(x: 10, y: 10)
    for location in locations! {
      XCTAssert(location.checkIntersection(location: locusCenter, locRadius: 10))
    }
  }
  
  func testIntersectionWithLeniency() throws {
    for location in locations! {
      XCTAssert(location.checkIntersectionLenient(location: location, multiplier: 0.5))
    }
  }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

enum TestError: Error {
  
  case JSONFileError
}
