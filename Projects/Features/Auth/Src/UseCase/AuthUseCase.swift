//
//  AuthUseCase.swift
//  AuthInterface
//
//  Created by Kanghos on 5/27/24.
//

import Foundation

import AuthInterface

import RxSwift
import Core
import Domain

public final class AuthUseCase: AuthUseCaseInterface {
  public func authenticate(userInfo: SNSUserInfo) -> RxSwift.Single<AuthResult> {
    guard let phoneNumber = userInfo.phoneNumber else {
      return .just(.needPhoneNumber)
    }

    return repository.checkUserExist(phoneNumber: phoneNumber)
      .flatMap { result -> Single<AuthResult> in
        // 가입 이력
        if result.isSignUp {
          // 선택한 SNS도 가입 이력이 있음
          if result.typeList.contains(userInfo.snsType) {
            let deviceKey = UserDefaultRepository.shared.fetch(for: .deviceKey, type: String.self) ?? "1"
            let request = UserSNSLoginRequest(email: userInfo.email ?? "", snsType: userInfo.snsType, snsUniqueId: userInfo.id, deviceKey: deviceKey)
            return userInfo.snsType == .normal
            ? .just(.login)
            : .just(.loginSNS(request))
          } else {
            let request = UserSNSSignUpRequest.init(email: userInfo.email ?? "", phoneNumber: phoneNumber, snsUniqueId: userInfo.id, snsType: userInfo.snsType)
            return .just(.signUpSNS(request))
          }
        } else {
          // 선택한 SNS로 회원가입
          let snsRequest = UserSNSSignUpRequest(email: userInfo.email ?? "", phoneNumber: phoneNumber, snsUniqueId: userInfo.id, snsType: userInfo.snsType)
          return userInfo.snsType == .normal
          ? .just(.signUp(userInfo))
          : .just(.signUpSNS(snsRequest))
        }
      }
  }

  public func processResult(_ result: AuthResult) -> Single<AuthNavigation> {
    switch result {
    case .login:
      return login()
        .map { AuthNavigation.main }
    case let .loginSNS(user):
      return loginSNS(user)
        .map { AuthNavigation.main }
    case let .signUp(user):
      return .just(AuthNavigation.signUp(user))
    case let .signUpSNS(request):
      return repository.signUpSNS(request)
        .map { _ in AuthNavigation.main }
    case .needPhoneNumber:
      return .error(AuthError.canNotOpenSNSURL)
    }
  }
  
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

  public func loginSNS(_ request: UserSNSLoginRequest) -> Single<Void> {
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

  public func auth(_ snsType: SNSType) -> Single<SNSUserInfo> {
    UserDefaultRepository.shared.saveModel(snsType, key: .snsType)
    let snsUserInfo = SNSUserInfo(snsType: snsType, id: "", email: nil, phoneNumber: nil)

    switch snsType {
    case .normal:
      return .just(snsUserInfo)
    case .kakao:
      return repository.kakaoLogin()
    case .naver, .apple, .google:
      return .just(snsUserInfo)
    }
  }
}
