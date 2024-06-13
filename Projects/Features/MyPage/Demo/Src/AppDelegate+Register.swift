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
    let tokenStore = UserDefaultTokenStore()
    let tokenProvider = DefaultTokenProvider()

    let locationService = LocationService()
    let kakaoService = KakaoAPIService()
    let contactService = ContactService()

    container.register(
      interface: SignUpUseCaseInterface.self,
      implement: {
        SignUpUseCase(
          repository: SignUpRepository(),
          locationService: locationService,
          kakaoAPIService: kakaoService,
          contactService: contactService,
          tokenStore: tokenStore
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


