//
//  KeychainTest.swift
//  FallingTests
//
//  Created by SeungMin on 2023/08/02.
//

import XCTest
@testable import Falling

class KeychainTest: XCTestCase {
  var obj: Keychain!
  
  override func setUp() {
    super.setUp()
    
    obj = Keychain.shared
    obj.clear()
  }
  
  // MARK: - Set
  func testSet() {
    XCTAssertTrue(obj.set("Hello", forKey: .accessToken))
    XCTAssertEqual("Hello", obj.get(.accessToken)!)
  }
  
  // MARK: - Get
  func testGet_returnNilWhenValueNotSet() {
    XCTAssert(obj.get(.accessToken) == nil)
  }
  
  // MARK: - Delete
  func testDelete() {
    obj.set("Hello", forKey: .accessToken)
    obj.delete(.accessToken)
    
    XCTAssert(obj.get(.accessToken) == nil)
  }
  
  func testDelete_deleteOnSingleKey() {
    obj.set("Hello", forKey: .accessToken)
    obj.set("Hello!!", forKey: .refreshToken)
    
    obj.delete(.accessToken)
    
    XCTAssertEqual("Hello!!", obj.get(.refreshToken)!)
  }
  
  // MARK: - Clear
  func testClear() {
    obj.set("Hello", forKey: .accessToken)
    obj.set("Hello!!", forKey: .refreshToken)
    
    obj.clear()
    
    XCTAssert(obj.get(.accessToken) == nil)
    XCTAssert(obj.get(.refreshToken) == nil)
  }
  
  // MARK: - Concurrency
  func testConcurrencyDoesntCrash() {
    let expectation = self.expectation(description: "Wait for write loop")
    let expectation2 = self.expectation(description: "Wait for write loop")
    
    let dataToWrite = "{ asdf ñlk BNALSKDJFÑLAKSJDFÑLKJ ZÑCLXKJ ÑALSKDFJÑLKASJDFÑLKJASDÑFLKJAÑSDLKFJÑLKJ}"
    obj.set(dataToWrite, forKey: .accessToken)
    
    var writes = 0
    
    let readQueue = DispatchQueue(label: "ReadQueue", attributes: [])
    readQueue.async {
      for _ in 0..<400 {
        let _: String? = synchronize( { completion in
          let result: String? = self.obj.get(.accessToken)
          DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(5)) {
              completion(result)
            }
          }
        }, timeoutWith: nil)
      }
    }
    let readQueue2 = DispatchQueue(label: "ReadQueue2", attributes: [])
    readQueue2.async {
      for _ in 0..<400 {
        let _: String? = synchronize( { completion in
          let result: String? = self.obj.get(.accessToken)
          DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(5)) {
              completion(result)
            }
          }
        }, timeoutWith: nil)
      }
    }
    let readQueue3 = DispatchQueue(label: "ReadQueue3", attributes: [])
    readQueue3.async {
      for _ in 0..<400 {
        let _: String? = synchronize( { completion in
          let result: String? = self.obj.get(.accessToken)
          DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(5)) {
              completion(result)
            }
          }
        }, timeoutWith: nil)
      }
    }
    
    let deleteQueue = DispatchQueue(label: "deleteQueue", attributes: [])
    deleteQueue.async {
      for _ in 0..<400 {
        let _: Bool = synchronize( { completion in
          let result = self.obj.delete(.accessToken)
          DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(5)) {
              completion(result)
            }
          }
        }, timeoutWith: false)
      }
    }
    
    let deleteQueue2 = DispatchQueue(label: "deleteQueue2", attributes: [])
    deleteQueue2.async {
      for _ in 0..<400 {
        let _: Bool = synchronize( { completion in
          let result = self.obj.delete(.accessToken)
          DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(5)) {
              completion(result)
            }
          }
        }, timeoutWith: false)
      }
    }
    
    let clearQueue = DispatchQueue(label: "clearQueue", attributes: [])
    clearQueue.async {
      for _ in 0..<400 {
        let _: Bool = synchronize( { completion in
          let result = self.obj.clear()
          DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(5)) {
              completion(result)
            }
          }
        }, timeoutWith: false)
      }
    }
    
    let clearQueue2 = DispatchQueue(label: "clearQueue2", attributes: [])
    clearQueue2.async {
      for _ in 0..<400 {
        let _: Bool = synchronize( { completion in
          let result = self.obj.clear()
          DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(5)) {
              completion(result)
            }
          }
        }, timeoutWith: false)
      }
    }
    
    let writeQueue = DispatchQueue(label: "WriteQueue", attributes: [])
    writeQueue.async {
      for _ in 0..<500 {
        let written: Bool = synchronize({ completion in
          DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(5)) {
              let result = self.obj.set(dataToWrite, forKey: .accessToken)
              completion(result)
            }
          }
        }, timeoutWith: false)
        if written {
          writes = writes + 1
        }
      }
      expectation.fulfill()
    }
    
    let writeQueue2 = DispatchQueue(label: "WriteQueue2", attributes: [])
    writeQueue2.async {
      for _ in 0..<500 {
        let written: Bool = synchronize({ completion in
          DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(5)) {
              let result = self.obj.set(dataToWrite, forKey: .accessToken)
              completion(result)
            }
          }
        }, timeoutWith: false)
        if written {
          writes = writes + 1
        }
      }
      expectation2.fulfill()
    }
    
    for _ in 0..<1000 {
      self.obj.set(dataToWrite, forKey: .accessToken)
      let _ = self.obj.get(.accessToken)
    }
    self.waitForExpectations(timeout: 30, handler: nil)
    
    XCTAssertEqual(1000, writes)
  }
}

// Synchronizes a asynch closure
// Ref: https://forums.developer.apple.com/thread/11519
func synchronize<ResultType>(_ asynchClosure: (_ completion: @escaping (ResultType) -> ()) -> Void,
                             
                             timeout: DispatchTime = DispatchTime.distantFuture,
                             timeoutWith: @autoclosure @escaping () -> ResultType) -> ResultType {
  let sem = DispatchSemaphore(value: 0)
  
  var result: ResultType?
  
  asynchClosure { (r: ResultType) -> () in
    result = r
    sem.signal()
  }
  _ = sem.wait(timeout: timeout)
  if result == nil {
    result = timeoutWith()
  }
  return result!
}
