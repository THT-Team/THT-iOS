//
//  ChatRoomTest.swift
//  ChatRoomTest
//
//  Created by Kanghos on 3/23/25.
//

import XCTest

//class ChatStore {
//  func fetch() -> [Chat]
//}
struct ChatMessageViewModel {
    let item: ChatMessage
    let showDate: Bool
    let showProfileImage: Bool
}

class ChatItemLoader {
    typealias Result = Swift.Result<[ChatMessage], Error>
    
    
    
    func load(_ completion: @escaping (Result) -> Void) {

        
    }
    
    private func messageStub() -> ChatMessage {
        ChatMessage(chatIdx: UUID().uuidString, sender: "any", senderUuid: UUID().uuidString, msg: "any message", imgUrl: "http://image.com", dataTime: Date())
    }
}

enum ChatMessageViewMapper {
    static func map(_ items: [ChatMessage]) -> [ChatMessageViewModel] {
        []
    }
}

final class ChatRoomTest: XCTestCase {
    
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
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
