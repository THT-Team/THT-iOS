//
//  HeartTarget.swift
//  Falling
//
//  Created by Kanghos on 2023/09/11.
//

import Foundation

import Networks

import Moya

public enum LikeTarget {
  case dontLike(id: String, topic: String)
  case like(id: String, topic: String)
  case list(request: HeartListReq)
  case reject(request: HeartRejectReq)
  case userInfo(id: String)
}

extension LikeTarget: BaseTargetType {

  public var path: String {
    switch self {
    case let .dontLike(id, topic):
      return "i-dont-like-you/\(id)/\(topic)"
    case let .like(id, topic):
      return "i-like-you/\(id)/\(topic)"
    case .list:
      return "like/receives"
    case .reject:
      return "like/reject"
    case .userInfo(let id):
      return "user/another/\(id)"
    }
  }

  public var method: Moya.Method {
    switch self {
    case .dontLike, .like, .reject: return .post
    default: return .get
    }
  }

  public var task: Task {
    switch self {
    case .list(let request):
			return .requestJSONEncodable(request)
    case .reject(let request):
      return .requestParameters(parameters: request.toDictionary(), encoding: URLEncoding.queryString)
    case .dontLike, .like, .userInfo:
      return .requestPlain
    }
  }
}
