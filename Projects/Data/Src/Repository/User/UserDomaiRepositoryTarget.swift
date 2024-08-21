//
//  UserDomaiRepositoryTarget.swift
//  Data
//
//  Created by Kanghos on 7/27/24.
//

import Foundation

import Networks

import Moya
import Domain

public enum UserDomainTarget {
  case idealTypes
  case interests
}

extension UserDomainTarget: BaseTargetType {

  public var path: String {
    switch self {
    case .idealTypes:
      return "ideal-types"
    case .interests:
      return "interests"
    }
  }

  public var method: Moya.Method {
    switch self {
    case .idealTypes, .interests:
      return .get
    }
  }

  public var task: Task {
    switch self {
    case .idealTypes, .interests:
      return .requestPlain
    }
  }
}
