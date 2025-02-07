//
//  AppDelegate+Register.swift
//  Like
//
//  Created by Kanghos on 2023/12/20.
//
import Foundation

import Core
import Data
import Domain

import LikeInterface
import Like

extension AppDelegate {
  var container: DIContainer {
    DIContainer.shared
  }

  func registerDependencies() {
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
