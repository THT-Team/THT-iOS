//
//  UserReport.swift
//  DSKit
//
//  Created by Kanghos on 6/18/24.
//

import Foundation

import Core


public enum UserReport: String, CaseIterable {
  case unpleasantPhoto = "불쾌한 사진"
  case fakeProfile = "허위 프로필"
  case photoTheft = "사진 도용"
  case profanity = "욕설 및 비방"
  case sharingIllegalFootage = "불법 촬영물 공유"
}

extension UserReport: MenuProtocol {
  
  public static var title: String {
    return "어떤 문제가 있나요?"
  }

  public static var menuList: [MenuProtocol] {
    return UserReport.allCases
  }

  public var key: String {
    return self.rawValue
  }

  public var label: String {
    return self.rawValue
  }
}
