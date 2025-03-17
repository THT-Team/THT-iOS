//
//  TokenProvider.swift
//  AuthInterface
//
//  Created by Kanghos on 5/8/24.
//

import Foundation
import RxSwift

public protocol TokenProvider {
  func login(phoneNumber: String, deviceKey: String) -> Single<Token>
  func loginSNS(_ loginRequest: SNSUserInfo.LoginRequest) -> Single<Token>
  func signUp(_ signUpRequest: SignUpReq) -> Single<Token>
  func signUpSNS(_ signUpRequest: SNSUserInfo.SignUpRequest) -> Single<Token>
  func refresh(_ token: Token) async throws -> Token
}
