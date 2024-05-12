//
//  AuthRepositoryInterface.swift
//  AuthInterface
//
//  Created by Kanghos on 5/8/24.
//

import Foundation

import RxSwift

public protocol AuthRepositoryInterface {
  func login(phoneNumber: String, deviceKey: String) -> Single<Token>
  func loginSNS(_ request: UserSNSLoginRequest) -> Single<Token>
}
