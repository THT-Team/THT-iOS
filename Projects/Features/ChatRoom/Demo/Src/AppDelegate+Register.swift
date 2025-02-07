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

extension AppDelegate {
  var container: DIContainer {
    DIContainer.shared
  }

  func registerDependencies() {
    container.register(
      interface: UserDomainUseCaseInterface.self,
      implement: {
        DefaultUserDomainUseCase(repository: DefaultUserDomainRepository())
      })

    container.register(
      interface: ChatUseCaseInterface.self,
      implement: {
        DefaultChatUseCase(repository: ChatRepository())
      })
  }
}
