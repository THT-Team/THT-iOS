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

    let environment: AppEnvironment = .release
    let provider = ServiceProvider(environment)

    // MARK: UseCase
    container.register(
      interface: SignUpUseCaseInterface.self,
      implement: { SignUpUseCase(
        repository: SignUpRepository(environment),
        emojiRepository: DefaultUserDomainRepository(environment),
        contactService: provider.contactService,
        authService: provider.tokenService,
        fileRepository: FileRepository(),
        imageService: provider.imageService
      )})

    container.register(
      interface: AuthUseCaseInterface.self,
      implement: {
        AuthUseCase(
          authRepository: AuthRepository(environment),
          tokenService: provider.tokenService,
          socialService: SocialLoginRepository()
        )})

    // MARK: Main Feature

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
            FallingRepository(provider.environment),
          likeRepository: LikeRepository(provider.environment)
        )})


    container.register(
      interface: LikeUseCaseInterface.self,
      implement: {
        LikeUseCase(
          repository: LikeRepository(provider.environment))})

    container.register(
      interface: ChatUseCaseInterface.self,
      implement: {
        DefaultChatUseCase(
          repository: ChatRepository(provider.environment))})

    container.register(
      interface: MyPageUseCaseInterface.self,
      implement: {
        MyPageUseCase(
          repository: UserRepository(provider.environment),
          contactsService: provider.contactService,
          authService: provider.tokenService,
          imageService: provider.imageService) })

    container.register(
      interface: LocationUseCaseInterface.self,
      implement: { LocationUseCase(
        locationService: provider.locationService,
        kakaoAPIService: KakaoAPIService(environment)) })

    container.register(interface: TalkUseCaseInterface.self) {
      DefaultTalkUseCase(
        socketInterface: SocketAuthDecorator.createAuthSocket(tokenService: provider.tokenService),
        tokenService: provider.tokenService)}
    
    container.register(interface: TopicUseCaseInterface.self) {
      TopicUseCase(
        repository: TopicRepository(provider.environment))}
  }
}
