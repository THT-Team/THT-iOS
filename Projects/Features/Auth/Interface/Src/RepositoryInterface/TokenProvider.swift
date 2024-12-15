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
  func loginSNS(_ userSNSLoginRequest: UserSNSLoginRequest) -> Single<Token>
  func signUp(_ signUpRequest: SignUpReq) -> Single<Token>
}
