//
//  AppDelegate+Register.swift
//  ChatRoom
//
//  Created by Kanghos on 1/20/25.
//

import Foundation

import Core
import Data
import Domain
import Auth

extension AppDelegate {
  var container: DIContainer {
    DIContainer.shared
  }

  func registerDependencies() {
    
    let environment: AppEnvironment = .debug
    let provider = ServiceProvider(environment)
    
    container.register(
      interface: UserDomainUseCaseInterface.self,
      implement: {
        DefaultUserDomainUseCase(
          repository: DefaultUserDomainRepository(.debug),
          tokenService: provider.tokenService)
      })

    container.register(
      interface: ChatUseCaseInterface.self,
      implement: {
          DefaultChatUseCase(repository: ChatRepository(.debug))
      })

    container.register(
      interface: TalkUseCaseInterface.self,
      implement: {
          MockTalkUseCase()
      })
  }
}
