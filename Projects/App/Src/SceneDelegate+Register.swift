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

    container.register(
      interface: AuthUseCaseInterface.self,
      implement: { AuthUseCase(authRepository: AuthRepository(),
                               tokenStore: tokenStore) })
    container.register(
      interface: SignUpUseCaseInterface.self,
      implement: { SignUpUseCase(
        repository: SignUpRepository(),
        locationService: LocationService(),
        kakaoAPIService: KakaoAPIService(),
        contactService: ContactService(),
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
          )
        )
      }
    )
  }
}
