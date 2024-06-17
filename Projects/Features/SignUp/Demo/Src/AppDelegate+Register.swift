//
//  AppDelegate+Register.swift
//  SignUpInterface
//
//  Created by kangho lee on 5/1/24.
//

import Foundation

import Core

import SignUp
import SignUpInterface
import AuthInterface
import Data

extension AppDelegate {
  var container: DIContainer {
    DIContainer.shared
  }

  func registerDependencies() {
    let authService = DefaultAuthService()
    let locationService = LocationService()
    let kakoService = KakaoAPIService()

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
      interface: LocationUseCaseInterface.self,
      implement: {
        LocationUseCase(locationService: locationService,
                        kakaoAPIService: kakoService)})

    container.register(
      interface: UserInfoUseCaseInterface.self,
      implement: {
        UserInfoUseCase(repository: UserDefaultUserInfoRepository())
      })
  }
}

