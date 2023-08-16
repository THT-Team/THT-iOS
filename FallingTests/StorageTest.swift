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
  
  var storage: StorageManager!
  var disposeBag = DisposeBag()
  
  override func setUpWithError() throws {
    try super.setUpWithError()
    storage = StorageManager()
  }
  
  override func tearDownWithError() throws {
    storage = nil
    try super.tearDownWithError()
  }
  
  func testImageDownload() throws {
    let expectation = self.expectation(description: "Wait for downloading")
    
    let key = "test"
    var receivedData: Data?
    var receivedError: Error?
    
    storage.download(key: key)
      .subscribe(with: self, onSuccess: { this, data in
        print("data - \(data)")
        receivedData = data
        expectation.fulfill()
      }, onFailure: { this, error in
        print(error.localizedDescription)
        receivedError = error
        expectation.fulfill()
      }).disposed(by: disposeBag)
    self.waitForExpectations(timeout: 10)
    
    XCTAssertNotNil(receivedData)
    XCTAssertNil(receivedError)
  }
  
  func testImageUpload() throws {
    let expectation = self.expectation(description: "Wait for uploading")
    
    let data = Data()
    let key = "test"
    var receivedUrl: URL?
    var receivedError: Error?
    
    storage.upload(data: data,
                   key: key)
    .subscribe(with: self, onSuccess: { this, url in
      print("url - \(url)")
      receivedUrl = url
      expectation.fulfill()
    }, onFailure: { this, error in
      print(error.localizedDescription)
      receivedError = error
      expectation.fulfill()
    }).disposed(by: disposeBag)
    self.waitForExpectations(timeout: 10)
    
    XCTAssertNotNil(receivedUrl)
    XCTAssertNil(receivedError)
  }
}
