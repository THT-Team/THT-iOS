////
////  AppDelegate+Register.swift
////  ChatRoom
////
////  Created by Kanghos on 1/20/25.
////
//
//import Foundation
//
//import Core
//import Data
//import Domain
//import Auth
//
//extension AppDelegate {
//  var container: DIContainer {
//    DIContainer.shared
//  }
//
//  func registerDependencies() {
//    let authService: AuthServiceType = DefaultAuthService()
//    
//    container.register(
//      interface: UserDomainUseCaseInterface.self,
//      implement: {
//        DefaultUserDomainUseCase(repository: DefaultUserDomainRepository())
//      })
//
//    container.register(
//      interface: ChatUseCaseInterface.self,
//      implement: {
//        DefaultChatUseCase(repository: ChatRepository())
//      })
//
//    container.register(interface: TalkUseCaseInterface.self) {
//      DefaultTalkUseCase(tokenStore: tokenStore)
//    }
//
//    container.register(
//      interface: AuthUseCaseInterface.self,
//      implement: {
//        AuthUseCase(authRepository: AuthRepository(authService: authService))
//      }
//    )
//  }
//}
