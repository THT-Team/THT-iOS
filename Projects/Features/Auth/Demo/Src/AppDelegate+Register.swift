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
    let authService = DefaultAuthService()

    container.register(
      interface: SignUpUseCaseInterface.self,
      implement: {
        SignUpUseCase(
          repository: SignUpRepository(authService: authService),
          contactService: ContactService()
        )
      }
    )

    container.register(
      interface: AuthUseCaseInterface.self,
      implement: {
        AuthUseCase(authRepository: AuthRepository(authService: authService))
      })

    container.register(
      interface: UserInfoUseCaseInterface.self,
      implement: {
        UserInfoUseCase(repository: UserDefaultUserInfoRepository())
      })
  }
}


