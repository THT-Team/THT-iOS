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
}

extension ChatTarget: BaseTargetType {

  public var path: String {
    switch self {
    case .rooms:
      return "chat/rooms"
    }
  }

  public var method: Moya.Method {
    switch self {
    default: return .get
    }
  }

  // Request의 파라미터를 결정한다.
  public var task: Task {
    switch self {

    default:
      return .requestPlain
    }
  }
}
