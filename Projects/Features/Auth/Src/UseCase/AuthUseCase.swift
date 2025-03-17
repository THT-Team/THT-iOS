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
  private let authRepository: AuthRepositoryInterface
  private let tokenService: TokenServiceType
  private let socialService: SocialLoginRepositoryInterface

  public init(
    authRepository: AuthRepositoryInterface,
    tokenService: TokenServiceType,
    socialService: SocialLoginRepositoryInterface
  ) {
    self.authRepository = authRepository
    self.tokenService = tokenService
    self.socialService = socialService
  }

  deinit {
    TFLogger.cycle(name: self)
  }
}

extension AuthUseCase: AuthUseCaseInterface {
  public func certificate(phoneNumber: String) -> RxSwift.Single<Int> {
    authRepository.certificate(phoneNumber: phoneNumber)
  }

  public func checkUserExists(phoneNumber: String) -> Single<UserSignUpInfoRes> {
    authRepository.checkUserExist(phoneNumber: phoneNumber)
      .flatMap { info in
        UserDefaultRepository.shared.saveModel(info, key: .sign_up_info)
        return .just(info)
      }
  }

  public func login() -> Single<Void> {
    tokenService.login()
  }
}

extension AuthUseCase {
  public func authenticate(_ type: Domain.AuthType) -> Single<AuthNavigation> {

    switch type {
    case .apple:
      return socialService.appleLogin()
        .flatMap { [unowned self] user in
          self.authenticate(user: user)
        }
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

  public func savePhoneNumber(_ phoneNumber: String) {
    UserDefaultRepository.shared.save(phoneNumber, key: .phoneNumber)
  }

  public func fetchPhoneNumber() -> String? {
    UserDefaultRepository.shared.fetch(for: .phoneNumber, type: String.self)
  }
}

extension AuthUseCase {
  private func authenticate(number: String) -> Single<AuthNavigation> {
    authRepository.checkUserExist(phoneNumber: number)
      .flatMap { [weak self] result -> Single<AuthNavigation> in
        guard let self else { return .error(AuthError.internalError) }
        UserDefaultRepository.shared.saveModel(result, key: .sign_up_info)
        return result.isSignUp
        ? tokenService.login().map { .main }
        : .just(.signUp(PendingUser(phoneNumber: number)))
      }
  }

  private func authenticate(user: SNSUserInfo) -> Single<AuthNavigation> {
    guard !user.phoneNumber.isEmpty else {
      return .just(.signUp(PendingUser(user)))
    }
    return authRepository.checkUserExist(phoneNumber: user.phoneNumber)
      .flatMap { [weak self] result -> Single<AuthNavigation> in
        guard let self else { return .error(AuthError.internalError) }

        if result.isSignUp {
          return result.typeList.contains(user.snsType)
          ? tokenService.loginSNS(user).map { .main }
          : tokenService.signUpSNS(user).map { .main }
        } else {
          return .just(.signUp(PendingUser(user)))
        }
      }
  }
}
