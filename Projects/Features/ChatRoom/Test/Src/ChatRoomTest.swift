import Foundation
import XCTest
import Domain
import Data

class ChatRoomTest: XCTestCase {
  func testSameSenderSameTime() throws {
    let me = UUID().uuidString
    let current = Date(timeIntervalSince1970: 1745708953)

    let messages = [
      createChatMessage(me, date: current), // false
      createChatMessage(me, date: current), // true
    ]

    let result = MessageMapper.map(messages, ownerID: me)

    XCTAssertEqual(result.map(\.showDate), [false, true])
  }

  func testSameSenderDifferentTime() throws {
    let me = UUID().uuidString
    let current = Date(timeIntervalSince1970: 1745708953)
    let oneMinuteAfter = current.addingTimeInterval(60)

    let messages = [
      createChatMessage(me, date: current), // true
      createChatMessage(me, date: oneMinuteAfter), // true
    ]

    let result = MessageMapper.map(messages, ownerID: me)

    XCTAssertEqual(result.map(\.showDate), [true, true])
  }

  func testDifferentSenderSameTime() throws {
    let me = UUID().uuidString
    let you = UUID().uuidString
    let current = Date(timeIntervalSince1970: 1745708953)

    let messages = [
      createChatMessage(me, date: current),
      createChatMessage(you, date: current),
    ]

    let result = MessageMapper.map(messages, ownerID: me)

    XCTAssertEqual(result.map(\.showDate), [true, true])
  }

  func testDifferentSenderDifferentTime() throws {
    let me = UUID().uuidString
    let you = UUID().uuidString
    let current = Date(timeIntervalSince1970: 1745708953)
    let oneMinuteAfter = current.addingTimeInterval(60)

    let messages = [
      createChatMessage(me, date: current),
      createChatMessage(you, date: oneMinuteAfter),
    ]

    let result = MessageMapper.map(messages, ownerID: me)

    XCTAssertEqual(result.map(\.showDate), [true, true])
  }

  func testDifferentDayKey() throws {

    let me = UUID().uuidString
    let calendar = Calendar.current
    let current = Date()
    let tommorow = calendar.date(byAdding: .day, value: 1, to: current)!

    let messages = [
      createChatMessage(me, date: current),
      createChatMessage(me, date: tommorow),
    ]

    let result = MessageSpliter.map(messages)

    XCTAssertEqual(result.keys.count, 2)
  }

  func testSameDay() throws {

    let me = UUID().uuidString
    let calendar = Calendar.current
    let current = Date()

    let messages = [
      createChatMessage(me, date: current),
      createChatMessage(me, date: current),
    ]

    let result = MessageSpliter.map(messages)

    XCTAssertEqual(result.keys.count, 1)
  }

  // MARK: - Helpers

  private func createChatMessage(_ senderID: String, date: Date) -> ChatMessage {
    ChatMessage(chatIdx: UUID().uuidString, sender: "any", senderUuid: senderID
                , msg: "any message", imgUrl: "http://message.com", dataTime: date)
  }
}
