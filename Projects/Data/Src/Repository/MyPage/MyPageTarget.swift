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
  case updateUserContacts([ContactType])
  case updateAlarmSetting([String:Bool])
}

extension MyPageTarget: BaseTargetType {
  public var path: String {
    switch self {
    case .user:
      return "user"
    case .updateUserContacts:
      return "user/friend-contact-list"
    case .updateAlarmSetting:
      return "user/alarm-agreement"
    }
  }
  
  public var method: Moya.Method {
    switch self {
    case .user:
      return .get
    case .updateAlarmSetting:
      return .patch
    case .updateUserContacts:
      return .post
    }
  }
  
  public var task: Moya.Task {
    switch self {
    case .updateUserContacts(let contacts):
      return .requestJSONEncodable(contacts)
    case .updateAlarmSetting(let settings):
      return .requestJSONEncodable(settings)
    default:
      return .requestPlain
    }
  }
}
  
