//
//  StorageTest.swift
//  FallingTests
//
//  Created by Kanghos on 2023/08/14.
//

import XCTest
import RxSwift
import RxMoya

@testable import Falling

final class StorageTest: XCTestCase {
  var disposeBag = DisposeBag()
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
      let expectation = self.expectation(description: "Wait for write loop")

      let storage = StorageManager()
      let data = Data()
      storage.upload(data: data, key: "test")
        .subscribe(with: self, onSuccess: { this, url in
          print(url)
          expectation.fulfill()
        }, onFailure: { this, error in
          print(error.localizedDescription)
          expectation.fulfill()
        }).disposed(by: disposeBag)
      self.waitForExpectations(timeout: 10)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
