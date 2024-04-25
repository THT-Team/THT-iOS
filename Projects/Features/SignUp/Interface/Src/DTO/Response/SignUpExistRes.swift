//
//  SignUpExistResponse.swift
//  SignUpInterface
//
//  Created by Kanghos on 2024/04/25.
//

import Foundation

public struct SignUpExistRes: Codable {
  let isSignUp: Bool
  let typeList: [SNSType]
}
