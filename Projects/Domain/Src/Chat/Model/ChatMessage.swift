//
//  ChatMessage.swift
//  Domain
//
//  Created by Kanghos on 1/5/25.
//

import Foundation

public struct ChatMessageItem: Hashable {
  public var message: ChatMessage
  public let senderType: MessageSendType
  
  public static func == (lhs: ChatMessageItem, rhs: ChatMessageItem) -> Bool {
    lhs.message.chatIdx == rhs.message.chatIdx
  }
  
  public func hash(into hasher: inout Hasher) {
    hasher.combine(message)
  }
}

public enum MessageSendType: Equatable {
  case incoming
  case outgoing
}

public struct ChatMessage: Equatable, Hashable {
  public let chatIdx: String
  public let sender: String
  public let senderUuid: String
  public let msg: String
  public let imgUrl: String
  public let dateTime: Date

  public init(chatIdx: String, sender: String, senderUuid: String, msg: String, imgUrl: String, dataTime: Date) {
    self.chatIdx = chatIdx
    self.sender = sender
    self.senderUuid = senderUuid
    self.msg = msg
    self.imgUrl = imgUrl
    self.dateTime = dataTime
  }
}

extension ChatMessage {
  public struct Request: Encodable {
    public let sender: String
    public let senderUUID: String
    public let imageURL: String
    public let message: String

    private enum CodingKeys: String, CodingKey {
      case sender
      case senderUUID = "senderUuid"
      case imageURL = "imgUrl"
      case message = "msg"
    }

    public init(sender: String, senderUUID: String, imageURL: String, message: String) {
      self.sender = sender
      self.senderUUID = senderUUID
      self.imageURL = imageURL
      self.message = message
    }

    public init(participant: ChatRoomInfo.Participant, message: String) {
      self.init(sender: participant.name, senderUUID: participant.id, imageURL: participant.profileURL, message: message)
    }
  }

  public struct Response: Decodable {
    public let chatIndex: String
    public let sender: String
    public let senderUUID: String
    public let message: String
    public let imageURL: String
    public let dateTime: Date

    private enum CodingKeys: String, CodingKey {
      case chatIndex = "chatIdx"
      case sender
      case senderUUID = "senderUuid"
      case imageURL = "imgUrl"
      case message = "msg"
      case dateTime
    }
  }

  public init(_ res: Response) {
    self.init(chatIdx: res.chatIndex, sender: res.sender, senderUuid: res.senderUUID, msg: res.message, imgUrl: res.imageURL, dataTime: res.dateTime)
  }
}

//extension ChatMessageType {
//  public static func isLinked(lhs: ChatMessageType, rhs: ChatMessageType) -> Bool {
//    let sender = lhs.senderType == rhs.senderType
//    let day = Calendar.current.isDate(lhs.message.dateTime, inSameDayAs: rhs.message.dateTime)
//    let minute = Calendar.current.isDate(lhs.message.dateTime, equalTo: rhs.message.dateTime, toGranularity: .minute)
//    
//    return sender && day && minute
//  }
//}
