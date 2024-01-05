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
  case like(id: String, topic: Int)
  case list(request: HeartListReq)
  case reject(request: HeartRejectReq)
  case userInfo(id: String)
}

extension LikeTarget: BaseTargetType {

  public var path: String {
    switch self {
    case .like(let id, let topic):
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
    case .like, .reject: return .post
    default: return .get
    }
  }

  // Request의 파라미터를 결정한다.
  public var task: Task {
    switch self {
    case .list(let request):
      return .requestParameters(parameters: request.toDictionary(), encoding: URLEncoding.queryString)
    case .reject(let request):
      return .requestParameters(parameters: request.toDictionary(), encoding: URLEncoding.queryString)
//    case .like(id: <#T##String#>, topic: <#T##Int#>)
//    case .userInfo(let id):

    default:
      return .requestPlain
    }
  }

}
