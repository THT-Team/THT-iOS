//
//  LikeTest.swift
//  LikeTest
//
//  Created by Kanghos on 3/30/25.
//

import XCTest
import LikeInterface
import Like
import Core
import Domain

class LikeRemoteStore {
  static var id: Int = 0
  func uniqueItem(idx: Int) -> Domain.Like {
    Like(dailyFallingIdx: 0, likeIdx: idx,
         topic: "토픽", issue: "이슈", userUUID: UUID().uuidString,
         username: "이름", profileURL: "URL", age: 20, address: "서울시 강남구 ", receivedTime: Date())
  }
}

final class LikeTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
      let store = LikeLocalStore()
      let remote = LikeRemoteStore()

      (0..<10).forEach { _ in
        store.save(makeUniqueItem(store: remote).likeIdx)
        }

      XCTAssertEqual(store.retrieveIndices(), [0, 1, 2, 3, 4, 5, 6, 7, 8, 9])
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

  func makeUniqueItem(store: LikeRemoteStore) -> Domain.Like {
    let item = store.uniqueItem(idx: LikeRemoteStore.id)
    LikeRemoteStore.id += 1
    return item
  }
}
