//
//  TokenProvider.swift
//  AuthInterface
//
//  Created by Kanghos on 5/8/24.
//

import Foundation
import RxSwift

public protocol TokenProvider {
  func refreshToken(token: Token, completion: @escaping (Result<Token, Error>) -> Void)
  func refresh(token: Token) -> Single<Token>
  func login(phoneNumber: String, deviceKey: String) -> Single<Token>
  func loginSNS(_ userSNSLoginRequest: UserSNSLoginRequest) -> Single<Token>
}
