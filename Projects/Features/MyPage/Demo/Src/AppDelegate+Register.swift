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
          repository: SignUpRepository(authService: authService),
          contactService: contactService
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
          repository: MyPageRepository(
            isStub: true,
            sampleStatusCode: 200,
            customEndpointClosure: nil),
          contactsService: contactService
        )
      }
    )

    container.register(
      interface: UserInfoUseCaseInterface.self,
      implement: {
        UserInfoUseCase(repository: UserDefaultUserInfoRepository())
      })
  }
}


