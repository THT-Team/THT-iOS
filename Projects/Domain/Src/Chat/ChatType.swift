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
  public let initialToken: String

  public init (
    host: String = "ws://3.34.157.62/websocket-endpoint",
    initialToken: String?,
    autoReconnect: Bool = true
  ) {
    self.host = host
    self.autoReconnect = autoReconnect
    self.initialToken = initialToken ?? ""
  }

  public var hostURL: URL {
    URL(string: host)!
  }

  public var connectHeader: [String: String] {
    ["Authorization": "\(initialToken)"]
  }
}

public enum ChatSignalType {
  case stompConnected
  case stompDisconnected
  case message(ChatMessageType)
  case receipt(String)
  case needAuth
}

extension ChatSignalType: Equatable {
  public static func == (lhs: ChatSignalType, rhs: ChatSignalType) -> Bool {
    switch (lhs, rhs) {
    case (.stompConnected, .stompConnected):
      return true
    case let (.message(lhsMessage), .message(rhsMessage)):
      return lhsMessage.message.chatIdx == rhsMessage.message.chatIdx
    case let (.receipt(lhsReceipt), receipt(rhsReceipt)):
      return lhsReceipt == rhsReceipt
    default: return false
    }
  }
}
