//
//  AuthServiceType.swift
//  AuthInterface
//
//  Created by Kanghos on 7/9/24.
//

import Foundation

import RxSwift
import Alamofire

public protocol SessionFactoryType {
  func createSession() -> Session
}

public protocol AuthServiceType {
  func clearToken()
  func login(phoneNumber: String, deviceKey: String) -> Single<Token>
  func loginSNS(_ userSNSLoginRequest: UserSNSLoginRequest) -> Single<Token>
  func signUp(_ signUpRequest: SignUpReq) -> Single<Token>
  func signUpSNS(_ request: UserSNSSignUpRequest) -> Single<Token>
  func needAuth() -> Bool
}
