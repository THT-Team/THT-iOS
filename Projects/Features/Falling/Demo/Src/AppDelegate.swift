//
//  AppDelegate.swift
//  App
//
//  Created by Hoo's MacBookPro on 12/3/23.
//

import UIKit

import Core
import Data

import FallingInterface
import Falling
import AuthInterface
import Auth
import Domain
//import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    registerDependencies()

    return true
  }

  // MARK: UISceneSession Lifecycle
  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }
}

extension AppDelegate {
  var container: DIContainer {
    DIContainer.shared
  }

  func registerDependencies() {
    let authService = DefaultAuthService()
    let session = SessionProvider.create()

    container.register(
      interface: AuthUseCaseInterface.self,
      implement: {
        AuthUseCase(
          authRepository: AuthRepository(authService: authService))})

    container.register(
      interface: FallingUseCaseInterface.self,
      implement: {
        FallingUseCase(
          repository: FallingRepository(session: session)
//            FallingRepository(
//            session: authService.createSession(),
//            isStub: true,
//            sampleStatusCode: 200,
//            customEndpointClosure: nil)
        )
      }
    )


  }
}

