//
//  AuthUseCaseInterface.swift
//  AuthInterface
//
//  Created by Kanghos on 5/8/24.
//

import Foundation

import RxSwift

public protocol AuthUseCaseInterface {
  func certificate(phoneNumber: String) -> Single<Int>
  func checkUserExists(phoneNumber: String) -> Single<UserSignUpInfoRes>
  func login(phoneNumber: String, deviceKey: String) -> Single<Void>
  func loginSNS(_ request: UserSNSLoginRequest) -> Single<Void>
}
