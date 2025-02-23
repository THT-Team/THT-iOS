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

public final class AuthUseCase {
  private let repository: AuthRepositoryInterface
  private let authService: AuthServiceType
  private let socialService: SocialLoginRepositoryInterface

  public init(
    authRepository: AuthRepositoryInterface,
    authService: AuthServiceType,
    socialService: SocialLoginRepositoryInterface
  ) {
    self.repository = authRepository
    self.authService = authService
    self.socialService = socialService
  }

  deinit {
    TFLogger.cycle(name: self)
  }
}

extension AuthUseCase: AuthUseCaseInterface {
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
    return authService.login()
      .map { _ in }
  }

  public func needAuth() -> Bool {
    authService.needAuth()
  }

  private func saveSNSType(_ sns: SNSType) {
    UserDefaultRepository.shared.saveModel(sns, key: .snsType)
  }
}

extension AuthUseCase {
  public func authenticate(_ type: Domain.AuthType) -> Single<AuthNavigation> {

    switch type {
    case .apple:
      return .error(AuthError.invalidSNSUser)
    case .google:
      return .error(AuthError.invalidSNSUser)
    case .naver:
      return .error(AuthError.invalidSNSUser)
    case .kakao:
      return socialService.kakaoLogin()
        .flatMap { [unowned self] user in
          self.authenticate(user: user)
        }
    case .phoneNumber(let number):
      return authenticate(number: number)
    }
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

  public func updateDeviceToken() -> Single<Void> {
    guard let deviceKey = UserDefaultRepository.shared.fetch(for: .deviceKey, type: String.self)
    else {
      return .error(AuthError.tokenNotFound)
    }
    return authService.updateDeviceToken(deviceKey)
  }
}

extension AuthUseCase {
  private func authenticate(number: String) -> Single<AuthNavigation> {
    repository.checkUserExist(phoneNumber: number)
      .flatMap { [weak self] result -> Single<AuthNavigation> in
        guard let self else { return .error(AuthError.internalError) }
        UserDefaultRepository.shared.saveModel(result, key: .sign_up_info)
        return result.isSignUp
        ? authService.login().map { _ in .main }
        : .just(.signUp(PendingUser(phoneNumber: number)))
      }
  }

  private func authenticate(user: SNSUserInfo) -> Single<AuthNavigation> {
    repository.checkUserExist(phoneNumber: user.phoneNumber)
      .flatMap { [weak self] result -> Single<AuthNavigation> in
        guard let self else { return .error(AuthError.internalError) }

        if result.isSignUp {
          return result.typeList.contains(user.snsType)
          ? authService.loginSNS(user).map { _ in .main }
          : authService.signUpSNS(user).map { _ in .main }
        } else {
          return .just(.signUp(PendingUser(user)))
        }
      }
  }
}
