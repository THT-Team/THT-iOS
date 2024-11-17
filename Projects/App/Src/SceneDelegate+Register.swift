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
import Domain

extension AppDelegate {
  var container: DIContainer {
    DIContainer.shared
  }

  func registerDependencies() {

    let authService = DefaultAuthService()
    let contactService = ContactService()
    let kakaoService = KakaoAPIService() // TODO: SNS Login 때 사용됨
    let fileRepository = FileRepository()
    let imageService: ImageServiceType = ImageService()

    container.register(
      interface: SignUpUseCaseInterface.self,
      implement: { SignUpUseCase(
        repository: SignUpRepository(),
        contactService: contactService,
        authService: authService,
        fileRepository: fileRepository, imageService: imageService
      )})

    container.register(
      interface: UserDomainUseCaseInterface.self,
      implement: { DefaultUserDomainUseCase(
        repository: DefaultUserDomainRepository())
      })

    container.register(
      interface: FallingUseCaseInterface.self,
      implement: {
        FallingUseCase(
          repository:
            FallingRepository(session: authService.createSession())
        )
      }
    )

    container.register(
      interface: AuthUseCaseInterface.self,
      implement: {
        AuthUseCase(authRepository: AuthRepository(authService: authService))
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
          repository: MyPageRepository(session: authService.createSession()),
          contactsService: contactService,
          authService: authService,
          imageService: imageService
        )
      }
    )

    container.register(
      interface: LocationUseCaseInterface.self,
      implement: { LocationUseCase(
        locationService: LocationService(),
        kakaoAPIService: kakaoService) }
    )
  }
}
