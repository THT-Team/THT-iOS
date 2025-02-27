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

import Moya

extension AppDelegate {
  var container: DIContainer {
    DIContainer.shared
  }

  func registerDependencies() {

    // MARK: Envrionment
    let provider = EnvironmentProvider(.release)
    let environment = provider.environment

    let tokenStore: TokenStore = provider.tokenStore
    let tokenRefresher = provider.tokenRefresher

    // MARK: Service
    let authService: AuthServiceType = DefaultAuthService(
      tokenStore: tokenStore,
      tokenProvider: DefaultTokenProvider(environment))
    let contactService = ContactService()
    let imageService: ImageServiceType = ImageService()

    // MARK: UseCase
    container.register(
      interface: SignUpUseCaseInterface.self,
      implement: { SignUpUseCase(
        repository: SignUpRepository(environment),
        contactService: contactService,
        authService: authService,
        fileRepository: FileRepository(), imageService: imageService
      )})

    container.register(
      interface: UserDomainUseCaseInterface.self,
      implement: { DefaultUserDomainUseCase(
        repository: DefaultUserDomainRepository(environment))
      })

    container.register(
      interface: FallingUseCaseInterface.self,
      implement: {
        FallingUseCase(
          repository:
            FallingRepository(environment))})

    container.register(
      interface: AuthUseCaseInterface.self,
      implement: {
        AuthUseCase(
          authRepository: AuthRepository(environment),
          authService: authService,
          socialService: SocialLoginRepository())})

    container.register(
      interface: LikeUseCaseInterface.self,
      implement: {
        LikeUseCase(
          repository: LikeRepository(.debug))})
    
    container.register(
      interface: ChatUseCaseInterface.self,
      implement: {
        DefaultChatUseCase(
          repository: ChatRepository(environment))})
    
    container.register(
      interface: MyPageUseCaseInterface.self,
      implement: {
        MyPageUseCase(
          repository: MyPageRepository(environment),
          contactsService: contactService,
          authService: authService,
          imageService: imageService)})

    container.register(
      interface: LocationUseCaseInterface.self,
      implement: { LocationUseCase(
        locationService: LocationService(),
        kakaoAPIService: KakaoAPIService(environment)) })

    container.register(interface: TalkUseCaseInterface.self) {
      DefaultTalkUseCase(
        socketInterface: SocketAuthDecorator.createAuthSocket(
          tokenStore: tokenStore,
          tokenRefresher: tokenRefresher),
        tokenStore: tokenStore)}
  }
}
