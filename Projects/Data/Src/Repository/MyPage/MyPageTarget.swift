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
  case user
}

extension MyPageTarget: BaseTargetType {
  public var path: String {
    switch self {
    case .user:
      return "user"
    }
  }
  
  public var method: Moya.Method {
    switch self {
    case .user:
      return .get
    }
  }
  
  public var task: Moya.Task {
    switch self {
    default:
      return .requestPlain
    }
  }
}
  
