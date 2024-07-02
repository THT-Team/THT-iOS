//
//  AppDelegate+Register.swift
//  Like
//
//  Created by Kanghos on 2023/12/20.
//

import Foundation

import Core

import SignUp
import SignUpInterface
import MyPage
import MyPageInterface

import Data

extension AppDelegate {
  var container: DIContainer {
    DIContainer.shared
  }

  func registerDependencies() {
    let authService = DefaultAuthService()

    let locationService = LocationService()
    let kakaoService = KakaoAPIService()
    let contactService = ContactService()

    container.register(
      interface: SignUpUseCaseInterface.self,
      implement: {
        SignUpUseCase(
          repository: SignUpRepository(),
          contactService: contactService,
          authService: authService,
          fileRepository: FileRepository(),
          imageService: ImageService()
        )
      }
    )
    container.register(
      interface: LocationUseCaseInterface.self,
      implement: {
        LocationUseCase(locationService: locationService, kakaoAPIService: kakaoService)
      }
    )
    container.register(
      interface: MyPageUseCaseInterface.self,
      implement: {
        MyPageUseCase(
          repository: MyPageRepository(session: authService.createSession()),
          contactsService: contactService,
          authService: authService,
          imageService: ImageService()
        )
      }
    )
  }
}


