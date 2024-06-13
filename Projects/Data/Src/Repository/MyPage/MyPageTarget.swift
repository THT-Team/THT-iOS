//
//  MyPageTarget.swift
//  Data
//
//  Created by SeungMin on 1/16/24.
//

import Networks

import Moya
import SignUpInterface

public enum MyPageTarget {
  case blockUserFriendContact(request: UserFriendContactReq)
}

extension MyPageTarget: BaseTargetType {
  public var path: String {
    switch self {
    case .blockUserFriendContact:
      return "user/friend-contact-list"
    }
  }
  
  public var method: Moya.Method {
    switch self {
    case .blockUserFriendContact:
      return .post
    }
  }
  
  public var task: Moya.Task {
    switch self {
    case let .blockUserFriendContact(request):
      return .requestParameters(parameters: request.toDictionary(), encoding: JSONEncoding.default)
    default:
      return .requestPlain
    }
  }
}
  
