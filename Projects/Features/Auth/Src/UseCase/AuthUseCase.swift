//
//  AuthUseCase.swift
//  AuthInterface
//
//  Created by Kanghos on 5/27/24.
//

import Foundation

import AuthInterface
import RxSwift
import KakaoSDKUser
import KakaoSDKCommon
import KakaoSDKAuth
import Core

public final class AuthUseCase: AuthUseCaseInterface {
  
  private let repository: AuthRepositoryInterface

  public init(authRepository: AuthRepositoryInterface) {
    self.repository = authRepository
  }

  deinit {
    TFLogger.cycle(name: self)
  }

  public func certificate(phoneNumber: String) -> RxSwift.Single<Int> {
    repository.certificate(phoneNumber: phoneNumber)
  }

  public func checkUserExists(phoneNumber: String) -> Single<UserSignUpInfoRes> {
    return repository.checkUserExist(phoneNumber: phoneNumber)
      .flatMap { info in
        UserDefaultRepository.shared.saveModel(info, key: .sign_up_info)
        return .just(info)
      }
  }

  public func login() -> Single<Void> {
    guard let phoneNumber = UserDefaultRepository.shared.fetch(for: .phoneNumber, type: String.self) else {
      return .error(AuthError.tokenNotFound)
    }
    let token = UserDefaultRepository.shared.fetch(for: .deviceKey, type: String.self) ?? "1"
    TFLogger.dataLogger.debug("\(token)")
    // TODO: deviceKey 변경 필요
    return repository.login(phoneNumber: phoneNumber, deviceKey: token)
      .map { _ in }
  }

  public func needAuth() -> Bool {
    repository.needAuth()
  }

  public func loginSNS(_ request: AuthInterface.UserSNSLoginRequest) -> Single<Void> {
    return repository.loginSNS(request)
      .map { _ in }
  }

  public func updateDeviceToken() -> Single<Void> {
    return repository.updateDeviceToken()
  }

  public func saveSNSType(type snsTYpe: SNSType, snsUUID: String?) {
    UserDefaultRepository.shared.save(snsTYpe.rawValue, key: .snsType)
    UserDefaultRepository.shared.save(snsUUID, key: .snsUUID)
  }

  public func saveDeviceKey(_ deviceKey: String) {
    UserDefaultRepository.shared.save(deviceKey, key: .deviceKey)
  }

  public func savePhoneNumber(_ phoneNumber: String) {
    UserDefaultRepository.shared.save(phoneNumber, key: .phoneNumber)
  }

  public func fetchPhoneNumber() -> String? {
    UserDefaultRepository.shared.fetch(for: .phoneNumber, type: String.self)
  }

  public func auth(_ snsType: SNSType) -> Single<AuthNavigation> {
    UserDefaultRepository.shared.saveModel(snsType, key: .snsType)
    var snsUserInfo = SNSUserInfo(snsType: snsType, id: "", email: nil, phoneNumber: nil)
    switch snsType {
    case .normal:
      return .just(.phoneNumber(snsUserInfo))
    case .kakao:
      return kakaoLogin()
        .flatMap({ [weak self] info in
          guard let self, let phoneNumber = info.phoneNumber else {
            return .just(.phoneNumber(info))
          }
          return self.checkUserExists(phoneNumber: phoneNumber)
            .flatMap { [weak self] result -> Single<AuthNavigation> in
              guard let self else {
                return .just(.phoneNumber(info))
              }
              return result.isSignUp
              ? self.login()
                .map { _ in .main }
              : .just(.policy(info))
            }
        })
    case .naver, .apple, .google:
      return .just(.phoneNumber(snsUserInfo))
    }
  }
}

extension AuthUseCase {
  private func kakaoLogin() -> Single<SNSUserInfo> {
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


