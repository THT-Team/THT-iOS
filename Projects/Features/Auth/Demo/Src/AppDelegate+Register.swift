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
          repository: SignUpRepository(),
          contactService: ContactService(),
          authService: authService,
          fileRepository: FileRepository(),
          imageService: ImageService()
        )
      }
    )

    container.register(
      interface: AuthUseCaseInterface.self,
      implement: {
        AuthUseCase(authRepository: AuthRepository(authService: authService))
      })
  }
}


