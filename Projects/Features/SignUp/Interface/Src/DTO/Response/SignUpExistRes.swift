//
//  SignUpExistResponse.swift
//  SignUpInterface
//
//  Created by Kanghos on 2024/04/25.
//

import Foundation

public struct SignUpExistRes: Codable {
  public let isSignUp: Bool
  public let typeList: [SNSType]
  
  public init(isSignUp: Bool, typeList: [SNSType]) {
    self.isSignUp = isSignUp
    self.typeList = typeList
  }
}
