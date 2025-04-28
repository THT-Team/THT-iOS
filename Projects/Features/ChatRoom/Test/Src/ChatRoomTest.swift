import Foundation
import XCTest
import Domain
import Data

public struct MessageViewModel: Equatable {
  public enum Align {
    case left
    case right
  }

  var showDate: Bool
  var showProfile: Bool
  var showName: Bool
  let model: ChatMessage
  let align: Align

  public init(showDate: Bool, showProfile: Bool, showName: Bool, model: ChatMessage, align: MessageViewModel.Align) {
    self.showDate = showDate
    self.showProfile = showProfile
    self.showName = showName
    self.model = model
    self.align = align
  }

  public init(model: ChatMessage, isMe: Bool) {
    self.showDate = true
    self.showProfile = !isMe
    self.showName = !isMe
    self.model = model
    self.align = isMe ? .right : .left
  }
}
private enum MessageSpliter {
  typealias Key = Date
  static func map(_ messages: [ChatMessage]) -> [Key: [ChatMessage]] {
    var dict = [Key: [ChatMessage]]()
    let formatter = DateFormatter()
    formatter.dateStyle = .short

    messages.forEach { message in
      let key = Calendar.current.startOfDay(for: message.dateTime)
      dict[key, default: []].append(message)
    }

    return dict
  }
}

private enum MessageMapper {
  enum MessageType {
    case dateHeader(Date)
    case message(MessageViewModel)
  }
  // 1. [Date: [Message]] 프로세싱

  /// 메세지 블록 처리
  static func map(_ messages: [ChatMessage], ownerID: String) -> [MessageViewModel] {
    var mutable = messages
      .map { message in
        let isMe = message.senderUuid == ownerID

        return MessageViewModel(
          showDate: true,
          showProfile: !isMe,
          showName: !isMe, model: message,
          align: isMe ? .right : .left
        )
      }
    var lastIndex: Int = 0

    mutable.enumerated().forEach { index, message in
      if index == 0 { return }
      lastIndex = index - 1
      var last = mutable[lastIndex]

      // Case: same sender && same minute
      if MessageMapper.isSameSenderAndSameTime(last, message) {
        last.showDate = false
        mutable[lastIndex] = last
      }
    }

    return mutable
  }

  private static func isSameSenderAndSameTime(_ lhs: MessageViewModel, _ rhs: MessageViewModel) -> Bool {
    lhs.model.senderUuid == rhs.model.senderUuid && MessageMapper.isSameTime(lhs: lhs.model.dateTime, rhs: rhs.model.dateTime)
  }

  private static func isSameTime(lhs: Date, rhs: Date) -> Bool {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyyMMddHHmm"

    return  formatter.string(from: lhs) == formatter.string(from: rhs)
  }
}

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
