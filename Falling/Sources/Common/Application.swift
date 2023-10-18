//
//  Application.swift
//  Falling
//
//  Created by Hoo's MacBookPro on 2023/07/29.
//

import UIKit

final class Application {
  static let shared = Application()
  
  func configurationMainInterface(window: UIWindow?) {
    let signUpController = UINavigationController()
    let signUpNavigator = SignUpNavigator(controller: signUpController)
    
    // TODO: 임시 토큰 저장
    Keychain.shared.set("test", forKey: .accessToken)
    
    // TODO: 임시 토큰 삭제
//    Keychain.shared.delete(.accessToken)
    
    guard let _ = Keychain.shared.get(.accessToken) else {
      window?.rootViewController = signUpController
      signUpNavigator.toRootView()
      return
    }
    window?.rootViewController = makeTabBarController()
  }
  
  private init() { }
  
  private func makeTabBarController() -> UIViewController {
    let heartService = HeartAPI(isStub: true, sampleStatusCode: 200, customEndpointClosure: nil)
    let fallingService = FallingAPI(isStub: true, sampleStatusCode: 200, customEndpointClosure: nil)
    
    let mainNavigationController = UINavigationController()
    let heartNavigationController = UINavigationController()
    let chatNavigationController = UINavigationController()
    let myPageNavigationController = UINavigationController()
    
    let mainNavigator = MainNavigator(controller: mainNavigationController, fallingService: fallingService)
    let heartNavigator = HeartNavigator(controller: heartNavigationController, heartService: heartService)
    let chatNavigator = ChatNavigator(controller: chatNavigationController)
    let myPageNavigator = MyPageNavigator(controller: myPageNavigationController)
    
    let dependency = TabBarComponent()
    let tabBarController = TFTabBarController(dependency: dependency)
    
    tabBarController.viewControllers = [
      createTabBarItem(navigationController: mainNavigationController,
                       title: "폴링",
                       image: FallingAsset.Image.falling.image.withRenderingMode(.alwaysOriginal),
                       selectedImage: FallingAsset.Image.fallingSelected.image.withRenderingMode(.alwaysOriginal)),
      createTabBarItem(navigationController: heartNavigationController,
                       title: "하트",
                       image: FallingAsset.Image.heart.image.withRenderingMode(.alwaysOriginal),
                       selectedImage: FallingAsset.Image.heartSelected.image.withRenderingMode(.alwaysOriginal)),
      createTabBarItem(navigationController: chatNavigationController,
                       title: "채팅",
                       image: FallingAsset.Image.chat.image.withRenderingMode(.alwaysOriginal),
                       selectedImage: FallingAsset.Image.chatSelected.image.withRenderingMode(.alwaysOriginal)),
      createTabBarItem(navigationController: myPageNavigationController,
                       title: "마이",
                       image: FallingAsset.Image.more.image.withRenderingMode(.alwaysOriginal),
                       selectedImage: FallingAsset.Image.moreSelected.image.withRenderingMode(.alwaysOriginal))
    ]
    
    mainNavigator.toList()
    heartNavigator.toList()
    chatNavigator.toList()
    myPageNavigator.toList()
    return tabBarController
  }
  
  private func createTabBarItem(navigationController: UINavigationController,
                                title: String,
                                image: UIImage,
                                selectedImage: UIImage) -> UINavigationController {
    navigationController.tabBarItem = UITabBarItem(
      title: title,
      image: image,
      selectedImage: selectedImage
    )
    return navigationController
  }
}
