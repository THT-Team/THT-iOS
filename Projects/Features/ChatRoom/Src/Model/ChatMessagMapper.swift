//
//  ChatMessagMapper.swift
//  ChatRoomTest
//
//  Created by kangho lee on 6/15/25.
//

import Foundation
import Domain

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
public enum MessageSpliter {
  public typealias Key = Date
  public static func map(_ messages: [ChatMessage]) -> [Key: [ChatMessage]] {
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

public enum MessageMapper {
  enum MessageType {
    case dateHeader(Date)
    case message(MessageViewModel)
  }
  // 1. [Date: [Message]] 프로세싱

  /// 메세지 블록 처리
  public static func map(_ messages: [ChatMessage], ownerID: String) -> [MessageViewModel] {
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
