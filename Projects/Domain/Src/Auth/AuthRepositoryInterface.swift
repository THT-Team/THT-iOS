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
}

public protocol SocialLoginRepositoryInterface {
  func kakaoLogin() -> Single<SNSUserInfo>
  func appleLogin() -> Single<SNSUserInfo>
}
