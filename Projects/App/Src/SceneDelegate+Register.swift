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
    let session = SessionProvider.create()
    let authService: AuthServiceType = DefaultAuthService()
    let contactService = ContactService()
    let kakaoService = KakaoAPIService()
    let fileRepository = FileRepository()
    let imageService: ImageServiceType = ImageService()
    let socketInterface: SocketInterface = SocketComponent(config: ChatConfiguration(), header: ["Authorization": "\(UserDefaultTokenStore.shared.getToken()?.accessToken ?? "")"])
    let authSocket: SocketInterface = SocketAuthDecorator(socketInterface, tokenRefresher: DefaultTokenRefresher(), tokenStore: UserDefaultTokenStore.shared)

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
            FallingRepository(session: session)
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
          repository: LikeRepository(session: session)
        )
      }
    )
    
    container.register(
      interface: ChatUseCaseInterface.self,
      implement: {
        DefaultChatUseCase(
          repository: ChatRepository(session: session))
      }
    )
    
    container.register(
      interface: MyPageUseCaseInterface.self,
      implement: {
        MyPageUseCase(
          repository: MyPageRepository(session: session),
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

    container.register(interface: TalkUseCaseInterface.self) {
      DefaultTalkUseCase(socketInterface: authSocket, userStore: UserDefaultRepository.shared)
    }
  }
}
