//
//  UserSignUpInfoRes.swift
//  AuthInterface
//
//  Created by Kanghos on 5/8/24.
//

import Foundation

public struct UserSignUpInfoRes: Codable {
  public let isSignUp: Bool
  public let typeList: [SNSType]
}
