//
//  AppDelegate+Register.swift
//  ChatInterface
//
//  Created by Kanghos on 2024/01/14.
//

import Foundation

import Core

import Chat
import ChatInterface
import Data

extension AppDelegate {
  var container: DIContainer {
    DIContainer.shared
  }

  func registerDependencies() {

    container.register(
      interface: ChatUseCaseInterface.self,
      implement: {
        ChatUseCase(
          repository: ChatRepository(
            isStub: true,
            sampleStatusCode: 200,
            customEndpointClosure: nil)
        )
      }
    )
  }
}

