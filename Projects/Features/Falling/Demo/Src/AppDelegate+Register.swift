//
//  AppDelegate+Register.swift
//  Like
//
//  Created by Kanghos on 2023/12/20.
//

import Core
import Data
import Domain

import FallingInterface
import Falling

extension AppDelegate {
  var container: DIContainer {
    DIContainer.shared
  }

  func registerDependencies() {
    let environment: AppEnvironment = .release
    let provider = ServiceProvider(environment)
    
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
            FallingRepository(provider.environment))})
    
    container.register(
      interface: ChatUseCaseInterface.self,
      implement: {
        DefaultChatUseCase(
          repository: ChatRepository(provider.environment))})
    
    container.register(interface: TalkUseCaseInterface.self) {
      DefaultTalkUseCase(
        socketInterface: SocketAuthDecorator.createAuthSocket(tokenService: provider.tokenService),
        tokenService: provider.tokenService)}
  }
}
