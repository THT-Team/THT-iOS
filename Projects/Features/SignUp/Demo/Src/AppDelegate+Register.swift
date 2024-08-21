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
import Domain

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
          repository: SignUpRepository(),
          contactService: ContactService(),
          authService: authService,
          fileRepository: FileRepository(),
          imageService: ImageService()
        )
      }
    )

    container.register(
      interface: UserDomainUseCaseInterface.self,
      implement: {
        DefaultUserDomainUseCase(repository: DefaultUserDomainRepository())
      })

    container.register(
      interface: LocationUseCaseInterface.self,
      implement: {
        LocationUseCase(locationService: locationService,
                        kakaoAPIService: kakoService)})
  }
}

