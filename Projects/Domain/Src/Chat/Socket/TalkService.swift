//
//  TalkService.swift
//  Domain
//
//  Created by Kanghos on 1/25/25.
//

import Foundation

public struct ChatConfiguration {
  public var host: String
  public var autoReconnect: Bool

  public init (host: String = "ws://3.34.157.62/websocket-endpoint", autoReconnect: Bool = true) {
    self.host = host
    self.autoReconnect = autoReconnect
  }

  public var hostURL: URL {
    URL(string: host)!
  }
}

public enum ChatSignalType {
  case stompConnected
  case message(ChatMessage)
  case receipt(String)
}

extension ChatSignalType: Equatable {
  public static func == (lhs: ChatSignalType, rhs: ChatSignalType) -> Bool {
    switch (lhs, rhs) {
    case (.stompConnected, .stompConnected):
      return true
    case let (.message(lhsMessage), .message(rhsMessage)):
      return lhsMessage.chatIdx == rhsMessage.chatIdx
    case let (.receipt(lhsReceipt), receipt(rhsReceipt)):
      return lhsReceipt == rhsReceipt
    default: return false
    }
  }
}
