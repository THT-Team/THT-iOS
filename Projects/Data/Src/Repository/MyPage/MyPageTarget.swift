//
//  MyPageTarget.swift
//  Data
//
//  Created by SeungMin on 1/16/24.
//

import Foundation

import Domain
import Networks

import Moya

public enum MyPageTarget {
  case fetchUserContacts
  case user
  case updateUserContacts([ContactType])
  case updateAlarmSetting([String:Bool])
  case withdrawal(reason: String, feedback: String)
  case logout

  case idealType([Int])
  case interests([Int])

  case introduction(String)
  case location(LocationReq)
  case profilePhoto([UserProfilePhoto])

  // MARK: Path
  case nickname(String)
  case email(String)
  case phoneNumber(String)
  case preferGender(String)
}

extension MyPageTarget: BaseTargetType {
  public var path: String {
    switch self {
    case .user:
      return "user"
    case .updateUserContacts, .fetchUserContacts:
      return "user/friend-contact-list"
    case .updateAlarmSetting:
      return "user/alarm-agreement"
    case .withdrawal:
      return "user/account-withdrawal"
    case .logout:
      return "user/logout"

    case .idealType:
      return "user/ideal-type"
    case .interests:
      return "user/interests"

    case .introduction:
      return "user/introduction"
    case .location:
      return "user/location"
    case .profilePhoto:
      return "user/profile-photo"

    case .nickname(let name):
      return "user/name/\(name)"
    case .email(let email):
      return "user/email/\(email)"
    case .phoneNumber(let phoneNumber):
      return "user/phone-number/\(phoneNumber)"
    case .preferGender(let gender):
      return "user/preferred-gender/\(gender)"
    }
  }
  
  public var method: Moya.Method {
    switch self {
    case .user, .fetchUserContacts:
      return .get
    case .updateAlarmSetting, .location, .introduction, .profilePhoto, .nickname, .email, .phoneNumber, .preferGender:
      return .patch
    case .updateUserContacts, .logout:
      return .post
    case .withdrawal:
      return .delete
    case .idealType, .interests:
      return .put
    }
  }
  
  public var task: Moya.Task {
    switch self {
    case let .withdrawal(reason, feedback):
      return .requestParameters(parameters: ["reason": reason, "feedback": feedback], encoding: JSONEncoding.default)
    case .fetchUserContacts, .user: return .requestPlain
    case .updateUserContacts(let contacts):
      return .requestJSONEncodable(contacts)
    case .updateAlarmSetting(let settings):
      return .requestJSONEncodable(settings)

    case let .location(location):
      return .requestJSONEncodable(location)
    case let .introduction(introduction): return
        .requestJSONEncodable(IntroductionReq(introduction: introduction)) /*.requestParameters(parameters: ["introduction": introduction], encoding: JSONEncoding.default)*/
    case let .idealType(emojies): return .requestParameters(parameters: ["idealTypeList": emojies], encoding: JSONEncoding.default)
    case let .interests(emojies): return .requestParameters(parameters: ["interestList": emojies], encoding: JSONEncoding.default)
    case let .profilePhoto(photos): return .requestJSONEncodable(PhotoReq(photos))
    case .nickname, .phoneNumber, .email, .preferGender, .logout:
      return .requestPlain
    }
  }
}

struct IntroductionReq: Codable {
  let introduction: String
}

struct PhotoReq: Encodable {
  let userProfilePhotoList: [UserProfilePhoto.Req]

  init(_ userProfilePhotoList: [UserProfilePhoto]) {
    self.userProfilePhotoList = userProfilePhotoList.map { .init(url: $0.url, priority: $0.priority) }
  }
}
