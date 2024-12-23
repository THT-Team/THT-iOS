//
//  AuthRepository.swift
//  Data
//
//  Created by Kanghos on 6/3/24.
//

import Foundation

import AuthInterface
import SignUpInterface
import Networks

import RxSwift
import RxMoya
import Moya

import Core
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

public final class AuthRepository: ProviderProtocol {

  public typealias Target = AuthTarget
  public var provider: MoyaProvider<Target>
  var authService: AuthServiceType

  public init(authService: AuthServiceType) {
    self.authService = authService
    self.provider = Self.makeProvider(session: SessionProvider.create())
    TFLogger.dataLogger.debug("init AuthRepo")
  }

  deinit {
    TFLogger.cycle(name: self)
  }
}

extension AuthRepository: AuthRepositoryInterface {
  public func checkUserExist(phoneNumber: String) -> RxSwift.Single<AuthInterface.UserSignUpInfoRes> {
    request(type: UserSignUpInfoRes.self, target: .checkExistence(phoneNumber: phoneNumber))
  }

  public func certificate(phoneNumber: String) -> Single<Int> {
    Single.just(PhoneValidationResponse(phoneNumber: "01012345678", authNumber: 123456))
      .map { $0.authNumber }
//    request(type: PhoneValidationResponse.self, target: .certificate(phoneNumber: phoneNumber)).map(\.authNumber)
  }

  public func login(phoneNumber: String, deviceKey: String) -> Single<AuthInterface.Token> {
    authService.login(phoneNumber: phoneNumber, deviceKey: deviceKey)
  }

  public func loginSNS(_ userSNSLoginRequest: AuthInterface.UserSNSLoginRequest) -> Single<AuthInterface.Token> {
    authService.loginSNS(userSNSLoginRequest)
  }

  public func signUpSNS(_ request: UserSNSSignUpRequest) -> Single<AuthInterface.Token> {
    authService.signUpSNS(request)
  }

  public func needAuth() -> Bool {
    authService.needAuth()
  }

  public func updateDeviceToken() -> Single<Void> {
    guard let deviceToken = UserDefaultRepository.shared.fetch(for: .deviceKey, type: String.self)
    else {
      return .error(AuthError.invalidDeviceKey)
    }
    return requestWithNoContent(target: .updateDeviceToken(deviceKey: deviceToken))
  }

  public func kakaoLogin() -> Single<SNSUserInfo> {
      .create { observer in
        if (UserApi.isKakaoTalkLoginAvailable()) {
          UserApi.shared.loginWithKakaoTalk { token, error in
            if let error {
              print(error.localizedDescription)
              observer(.failure(error))
            }
            if let token {
              UserApi.shared.me { user, error in
                if let error {
                  print(error.localizedDescription)
                  observer(.failure(error))
                }
                if let user, let id = user.id {
                  if let phoneNumber = user.kakaoAccount?.phoneNumber?.sanitizedPhoneNumber() {
                    UserDefaultRepository.shared.save(phoneNumber, key: .phoneNumber)
                  }
                  observer(.success(
                    SNSUserInfo(snsType: .kakao, id: String(id), email: user.kakaoAccount?.email, phoneNumber: user.kakaoAccount?.phoneNumber?.sanitizedPhoneNumber()))
                  )
                } else {
                  observer(.failure(AuthError.invalidSNSUser))
                }
              }
            }
          }
        } else {
          observer(.failure(AuthError.canNotOpenSNSURL))
        }
        return Disposables.create { }
      }
  }
}

