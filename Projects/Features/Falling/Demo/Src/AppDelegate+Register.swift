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
    let provider = EnvironmentProvider(.debug)
    let environment = provider.environment
    
    let tokenStore: TokenStore = provider.tokenStore
    let tokenRefresher = provider.tokenRefresher
    
    container.register(interface: TalkUseCaseInterface.self) {
      DefaultTalkUseCase(
        socketInterface: SocketAuthDecorator.createAuthSocket(
          tokenStore: tokenStore,
          tokenRefresher: tokenRefresher),
        tokenStore: tokenStore)}
    
    container.register(
      interface: UserDomainUseCaseInterface.self,
      implement: { DefaultUserDomainUseCase(
        repository: DefaultUserDomainRepository(environment))
      })
    
    container.register(
      interface: ChatUseCaseInterface.self,
      implement: {
        DefaultChatUseCase(
          repository: ChatRepository(environment))})
    
    container.register(
      interface: FallingUseCaseInterface.self,
      implement: {
        FallingUseCase(
          repository:
            FallingRepository(environment))})
  }
}
