//
//  AppDelegate+Register.swift
//  AuthDemo
//
//  Created by Kanghos on 6/3/24.
//

import Foundation

import Core

import SignUp
import SignUpInterface
import AuthInterface
import Auth
import Data

extension AppDelegate {
  var container: DIContainer {
    DIContainer.shared
  }

  func registerDependencies() {
    let tokenStore = UserDefaultTokenStore()
    let tokenProvider = DefaultTokenProvider()

    container.register(
      interface: SignUpUseCaseInterface.self,
      implement: {
        SignUpUseCase(
          repository: SignUpRepository(),
          locationService: LocationService(),
          kakaoAPIService: KakaoAPIService(),
          contactService: ContactService(),
          tokenStore: tokenStore
        )
      }
    )

    container.register(
      interface: AuthUseCaseInterface.self,
      implement: {
        AuthUseCase(
          authRepository: AuthRepository(tokenStore: tokenStore, tokenProvider: tokenProvider),
          tokenStore: tokenStore
        )
      })

    container.register(
      interface: UserInfoUseCaseInterface.self,
      implement: {
        UserInfoUseCase(repository: UserDefaultUserInfoRepository())
      })
  }
}


