//
//  AuthRepositoryInterface.swift
//  AuthInterface
//
//  Created by Kanghos on 5/8/24.
//

import Foundation

import RxSwift

public protocol AuthRepositoryInterface {
  func certificate(phoneNumber: String) -> Single<Int>
  func checkUserExist(phoneNumber: String) -> Single<UserSignUpInfoRes>
  func login(phoneNumber: String, deviceKey: String) -> Single<Token>
  func loginSNS(_ userSNSLoginRequest: UserSNSLoginRequest) -> Single<Token>
  func refresh(completion: @escaping (Result<Token, Error>) -> Void)
  func refresh() -> Single<Token>
  func needAuth() -> Bool
}
