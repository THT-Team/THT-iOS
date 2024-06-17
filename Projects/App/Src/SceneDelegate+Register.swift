//
//  SceneDelegate+Register.swift
//  App
//
//  Created by Kanghos on 2023/11/26.
//

import UIKit

import Core
import Data

import Feature
import Networks

extension AppDelegate {
  var container: DIContainer {
    DIContainer.shared
  }

  func registerDependencies() {
    let tokenStore = UserDefaultTokenStore()
    let tokenProvider = DefaultTokenProvider()

    let contactService = ContactService()
    let kakaoService = KakaoAPIService()
    let locationService = LocationService()

    container.register(
      interface: UserInfoUseCaseInterface.self,
      implement: { UserInfoUseCase(repository: UserDefaultUserInfoRepository()) })

    container.register(
      interface: AuthUseCaseInterface.self,
      implement: { AuthUseCase(authRepository: AuthRepository(tokenStore: tokenStore, tokenProvider: tokenProvider),
                               tokenStore: tokenStore) })
    container.register(
      interface: SignUpUseCaseInterface.self,
      implement: { SignUpUseCase(
        repository: SignUpRepository(),
        locationService: locationService,
        kakaoAPIService: kakaoService,
        contactService: contactService,
        tokenStore: tokenStore)
      })
    
    container.register(
      interface: FallingUseCaseInterface.self,
      implement: {
        FallingUseCase(
          repository: FallingRepository(
            isStub: true,
            sampleStatusCode: 200,
            customEndpointClosure: nil
          )
        )
      }
    )
    
    container.register(
      interface: LikeUseCaseInterface.self,
      implement: {
        LikeUseCase(
          repository: LikeRepository(
            isStub: true,
            sampleStatusCode: 200,
            customEndpointClosure: nil
          )
        )
      }
    )
    
    container.register(
      interface: ChatUseCaseInterface.self,
      implement: {
        ChatUseCase(
          repository: ChatRepository(
            isStub: true,
            sampleStatusCode: 200,
            customEndpointClosure: nil
          )
        )
      }
    )
    
    container.register(
      interface: MyPageUseCaseInterface.self,
      implement: {
        MyPageUseCase(
          repository: MyPageRepository(
            isStub: true,
            sampleStatusCode: 200,
            customEndpointClosure: nil
          ), contactsService: contactService
        )
      }
    )

    container.register(
      interface: LocationUseCaseInterface.self,
      implement: { LocationUseCase(
        locationService: locationService,
        kakaoAPIService: kakaoService) }
    )
  }
}
