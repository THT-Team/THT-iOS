//
//  AppDelegate+Register.swift
//  SignUpInterface
//
//  Created by kangho lee on 5/1/24.
//

import Foundation

import Core

import SignUp
import SignUpInterface
import Data

extension AppDelegate {
  var container: DIContainer {
    DIContainer.shared
  }

  func registerDependencies() {

    container.register(
      interface: SignUpUseCaseInterface.self,
      implement: {
        SignUpUseCase(
          repository: SignUpRepository(
            isStub: false,
            sampleStatusCode: 200,
            customEndpointClosure: nil)
        )
      }
    )
  }
}

