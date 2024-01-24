//
//  FallingTarget.swift
//  Data
//
//  Created by SeungMin on 1/11/24.
//

import Foundation

import Networks

import Moya

public enum FallingTarget {
  case talkKeyword
  case dailyKeyword
  case choiceTopic(Int)
  case users(FallingUserReq)
}

extension FallingTarget: BaseTargetType {
  public var path: String {
    switch self {
    case .talkKeyword:
      return "all/talk-keyword"
    case .dailyKeyword:
      return "falling/daily-keyword"
    case .choiceTopic(let dailyFallingIndex):
      return "falling/choice/daily-keyword/\(dailyFallingIndex)"
    case .users:
      return "main/daily-falling/users"
    }
  }

  public var method: Moya.Method {
    switch self {
    case .choiceTopic, .users: return .post
    default: return .get
    }
  }

  // Request의 파라미터를 결정한다.
  public var task: Task {
    switch self {
    case .users(let request):
      return .requestParameters(parameters: request.toDictionary(), encoding: JSONEncoding.default)
    default:
      return .requestPlain
    }
  }

}
