//
//  SignUpTarget+SampleData.swift
//  Data
//
//  Created by kangho lee on 5/1/24.
//

import Foundation

import Networks

import Moya

extension SignUpTarget {
  public var sampleData: Data {
    switch self {
    case .certificate:
      return Data(
        """
    {
      "phoneNumber": "01012345678",
      "authNumber": 123456
    }
    """.utf8)
    case .checkNickname:
      return Data(
        """
    {
      "isDuplicate": true
    }
    """.utf8)
    case .checkExistence:
      return Data(
        """
    {
      "isSignUp": false,
      "typeList": [
        "NORMAL",
        "KAKAO",
        "NAVER",
        "GOOGLE"
      ]
    }
    """.utf8)

    default:
      return Data(
    """
    """.utf8)
    }
  }
}
