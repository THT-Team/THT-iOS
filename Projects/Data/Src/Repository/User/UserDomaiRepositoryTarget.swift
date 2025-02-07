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
  case report(String, String)
  case block(String)
  case user(_ id: String)
}

extension UserDomainTarget: BaseTargetType {

  public var path: String {
    switch self {
    case .idealTypes:
      return "ideal-types"
    case .interests:
      return "interests"
    case let .block(id):
      return "user/block/\(id)"
    case let .report(id, reason):
      return "user/report"
    case let .user(id):
      return "user/another/\(id)"
    }
  }

  public var method: Moya.Method {
    switch self {
    case .idealTypes, .interests, .user:
      return .get
    case .block:
      return .post
    case .report:
      return .post
    }
  }

  public var task: Task {
    switch self {
    case .idealTypes, .interests, .user:
      return .requestPlain
    case .block:
      return .requestPlain
    case let .report(id, reason):
      return .requestJSONEncodable(UserReportReq(id: id, reason: reason))
    }
  }
}
