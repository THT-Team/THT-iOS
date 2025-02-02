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
  case users(FallingUserReq)
}

extension FallingTarget: BaseTargetType {
  public var path: String {
    switch self {
    case .users:
      return "main/daily-falling/users"
    }
  }

  public var method: Moya.Method {
    switch self {
    case .users: return .post
    }
  }

  // Request의 파라미터를 결정한다.
  public var task: Task {
    switch self {
    case .users(let request):
      return .requestJSONEncodable(request)
    }
  }
}
