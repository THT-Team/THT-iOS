//
//  AuthServiceType.swift
//  AuthInterface
//
//  Created by Kanghos on 7/9/24.
//

import Foundation

import RxSwift


public protocol AuthServiceType {
  func clearToken()
  func login() -> Single<Token>
  func loginSNS(_ user: SNSUserInfo) -> Single<Token>
  func signUpSNS(_ user: SNSUserInfo) -> Single<Token>
  func signUp(_ user: PendingUser, contacts: [ContactType], urls: [String]) -> Single<Token>
  func needAuth() -> Bool
  func updateDeviceToken(_ token: String) -> Single<Void>
}
