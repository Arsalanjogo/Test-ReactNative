//
//  utilArrayTests.swift
//  jogoTests
//
//  Created by Muhammad Nauman on 24/11/2021.
//

import XCTest
@testable import Football433

class utilArrayTests: XCTestCase {

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func testThreadSafety() throws {
      let group = DispatchGroup()
      let obj = UtilArrayList<Int>(maxSize: 100)

      for _ in 0...1000 {
         group.enter()

        DispatchQueue.global().async {
          let sleepVal = arc4random() % 1000
          usleep(sleepVal)
          obj.addArray(value: [5, 6, 7, 8, 9, 10])
          obj.clear()
          if let _ = try? obj.get(index: 5){
            XCTFail("Something is fishy inside Utilarray funcs")
          }
          let _ = obj.getReversed()
          group.leave()
        }
      }

      let result = group.wait(timeout: DispatchTime.now() + 5)

      XCTAssert(result == .success)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
