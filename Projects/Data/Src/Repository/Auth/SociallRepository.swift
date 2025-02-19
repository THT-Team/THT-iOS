//
//  SocailRepository.swift
//  Data
//
//  Created by Kanghos on 2/15/25.
//  Copyright © 2025 THT. All rights reserved.
//

import Foundation
import Domain

import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser

import Core

import RxSwift

public final class SocialLoginRepository: SocialLoginRepositoryInterface {
  public init() { }
  public func kakaoLogin() -> Single<SNSUserInfo> {
      .create { observer in
        if (UserApi.isKakaoTalkLoginAvailable()) {
          UserApi.shared.loginWithKakaoTalk { token, error in
            if let error {
              print(error.localizedDescription)
              return observer(.failure(error))
            }
            guard let _ = token else {
              return observer(.failure(AuthError.invalidSNSUser))
            }
            UserApi.shared.me { user, error in
              if let error {
                print(error.localizedDescription)
                observer(.failure(error))
              }
              guard
                let user,
                let id = user.id,
                let phoneNumber = user.kakaoAccount?.phoneNumber?.sanitizedPhoneNumber(),
                let email = user.kakaoAccount?.email
              else {
                return observer(.failure(AuthError.invalidSNSUser))
              }
              return observer(.success(
                SNSUserInfo(snsType: .kakao, id: String(id), email: email, phoneNumber: phoneNumber)
              ))
            }
          }
        } else {
          observer(.failure(AuthError.canNotOpenSNSURL))
        }
        return Disposables.create { }
      }
  }
}
