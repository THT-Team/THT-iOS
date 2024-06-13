//
//  UserNicknameValidResponse.swift
//  SignUpInterface
//
//  Created by kangho lee on 5/1/24.
//

import Foundation

public struct UserNicknameValidRes: Codable {
  public let isDuplicate: Bool
  
  public init(isDuplicate: Bool) {
    self.isDuplicate = isDuplicate
  }
}
