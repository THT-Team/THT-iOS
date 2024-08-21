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
    let token = UserDefaultRepository.shared.fetch(for: .deviceKey, type: String.self) ?? ""
    TFLogger.dataLogger.debug("\(token)")
    return repository.login(phoneNumber: phoneNumber, deviceKey: UserDefaultRepository.shared.fetch(for: .deviceKey, type: String.self) ?? "")
      .map { _ in }
  }

  public func needAuth() -> Bool {
    repository.needAuth()
  }

  public func loginSNS(_ request: AuthInterface.UserSNSLoginRequest) -> Single<Void> {
    return repository.loginSNS(request)
      .map { _ in }
  }

  // TODO: token을 어디서 집어넣을 지 생각해볼 것 e,g Authenticator
  public func refresh() -> Single<Void> {
    return repository.refresh()
      .map { _ in }
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

  public func auth(_ snsType: SNSType) -> Single<AuthType> {
    UserDefaultRepository.shared.saveModel(snsType, key: .snsType)
    switch snsType {
    case .kakao:
      return kakaoLogin()
        .map { AuthType.sns($0) }
    case .normal:
      return .just(.phoneNumber)
    case .naver:
      return .just(.sns(.init(snsType: snsType, id: "", email: nil, phoneNumber: nil)))
//    case .google:
//      <#code#>
//    case .apple:
//      .
    default: return .just(.phoneNumber)
    }
  }

  private func kakaoLogin() -> Single<SNSUserInfo> {
    .create { observer in
      if (UserApi.isKakaoTalkLoginAvailable()) {
        UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
          if let error = error {
            print(error)
            observer(.failure(error))
          }
          else {
            print("loginWithKakaoTalk() success.")
            if let oauthToken {
              print(oauthToken)
              let info = SNSUserInfo(snsType: .kakao, id: "", email: nil, phoneNumber: nil)
              observer(.success(info))
            } else {
              observer(.failure(AuthError.tokenNotFound))
            }
          }
        }
      } else {
        observer(.failure(AuthError.tokenNotFound))
      }
      return Disposables.create { }
    }
  }
}
