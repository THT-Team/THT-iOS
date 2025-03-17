//
//  AuthServiceType.swift
//  AuthInterface
//
//  Created by Kanghos on 7/9/24.
//

import Foundation

import RxSwift


public protocol TokenServiceType {
  func clear()
  func login() -> Single<Void>
  func loginSNS(_ user: SNSUserInfo) -> Single<Void>
  func signUpSNS(_ user: SNSUserInfo) -> Single<Void>
  func signUp(_ user: PendingUser, contacts: [ContactType], urls: [String]) -> Single<Void>
  func getToken() -> Token?

  @discardableResult
  func refreshToken() async throws -> Token
}
