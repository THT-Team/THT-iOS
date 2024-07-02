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

public protocol AuthServiceType: SessionFactoryType {
  var cachedToken: Token? { get set }

  func clearToken()
  func refreshToken(completion: @escaping (Result<Token, Error>) -> Void)
  func refresh() -> Single<Token>
  func login(phoneNumber: String, deviceKey: String) -> Single<Token>
  func loginSNS(_ userSNSLoginRequest: UserSNSLoginRequest) -> Single<Token>
  func signUp(_ signUpRequest: SignUpReq) -> Single<Token>
  func needAuth() -> Bool
  func sessionPublisher() -> Single<Session>
}
