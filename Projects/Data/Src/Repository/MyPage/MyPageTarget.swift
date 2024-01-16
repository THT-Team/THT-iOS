//
//  MyPageTarget.swift
//  Data
//
//  Created by SeungMin on 1/16/24.
//

import Networks

import Moya

public enum MyPageTarget {
  case test
}

extension MyPageTarget: BaseTargetType {
  public var path: String {
    switch self {
    case .test:
      return ""
    }
  }
  
  public var method: Moya.Method {
    switch self {
    case .test:
      return .get
    }
  }
  
  public var task: Moya.Task {
    switch self {
    case .test:
      return .requestPlain
    }
  }
}
  
