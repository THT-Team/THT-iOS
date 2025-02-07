//
//  ChatTarget.swift
//  Data
//
//  Created by Kanghos on 2024/01/11.
//

import Foundation

import Networks

import Moya

public enum ChatTarget {
  case rooms
  case room(String)
  case out(String)
  case history(roomNo: String, chatIdx: String?, size: Int)
}

extension ChatTarget: BaseTargetType {

  public var path: String {
    switch self {
    case .rooms:
      return "chat/rooms"
    case let .room(index):
      return "chat/room/\(index)"
    case let .out(index):
      return "chat/out/room/\(index)"
    case .history:
      return "chat/history"
    }
  }

  public var method: Moya.Method {
    switch self {
    case .rooms, .room, .history: return .get
    case .out: return .post
    }
  }

  public var task: Task {
    switch self {
    case .rooms:
      return .requestPlain
    case .room:
      return .requestPlain
    case .out:
      return .requestPlain
    case let .history(roomNo, chatIdx, size):
      return .requestParameters(parameters: ChatHistoryReq(roomNo: roomNo, chatIndex: chatIdx, size: size).toDictionary(), encoding: URLEncoding.queryString)
    }
  }
}
