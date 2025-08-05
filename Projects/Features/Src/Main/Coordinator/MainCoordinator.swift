//
//  MainCoordinator.swift
//  Feature
//
//  Created by Kanghos on 2023/12/06.
//

import Foundation
import Combine

import Core

import FallingInterface
import Falling

import LikeInterface
import Like

import ChatInterface
import Chat

import ChatRoom

import MyPageInterface
import MyPage
import Domain

public protocol MainViewControllable: ViewControllable {
  func setViewController(_ viewControllables: [(ViewControllable)])
}

public final class MainCoordinator: BaseCoordinator, MainCoordinating {
  @Injected var talkUseCase: TalkUseCaseInterface
  @Injected var myPageUseCase: MyPageUseCaseInterface
  @Injected var chatUseCase: ChatUseCaseInterface
  @Injected var likeUseCase: LikeUseCaseInterface
  @Injected var userdomainUseCase: UserDomainUseCaseInterface
  @Injected var locationUseCase: LocationUseCaseInterface

  public var finishFlow: (() -> Void)?
  var cancellables = Set<AnyCancellable>()

  private let mainViewControllable: MainViewControllable
  
  init(
    viewControllable: MainViewControllable
  ) {
    self.mainViewControllable = viewControllable

    super.init(viewControllable: self.mainViewControllable)

    attachTab()
    NotificationCenter.default.post(Notification(name: .requestPushNotification, object: nil))
  }

  public override func start() {
    replaceWindowRootViewController(rootViewController: self.mainViewControllable)
    childCoordinators.forEach { child in
      child.start()
    }
  }
  
  func attachTab() {
    let chatRoomBuilder = ChatRoomBuilder(ChatRoomFactory(
      talkUseCase: talkUseCase,
      userUseCase: userdomainUseCase,
      chatUseCase: chatUseCase))

    let like = LikeBuilder(
      chatRoomBuilder: chatRoomBuilder,
      factory: LikeFactory(
        chatRoomBuilder: chatRoomBuilder,
        userUseCase: userdomainUseCase,
        likeUseCase: likeUseCase
      ))
      .build(rootViewControllable: NavigationViewControllable())

    let falling = FallingBuilder(chatRoomBuilder: chatRoomBuilder)
      .build(rootViewControllable: NavigationViewControllable())

    let chat = ChatBuilder(
      chatRoomBuilder: chatRoomBuilder,
      factory: ChatFactory(chatRoomBuilder: chatRoomBuilder, chatUseCase: chatUseCase))
      .build(rootViewControllable: NavigationViewControllable())

    let myPage = MyPageBuilder(
      factory: MyPageFactory(
        userStore: UserStore(myPageUseCase, locationUseCase: locationUseCase),
        myPageUseCase: myPageUseCase,
        userDomainUseCase: userdomainUseCase,
        locationUseCase: locationUseCase,
        inquiryBuilder: InquiryBuilder())
    ).build(rootViewControllable: NavigationViewControllable())

    self.mainViewControllable.setViewController([
      falling,
      like,
      chat,
      myPage
    ].map(\.viewControllable))

    like.viewControllable.uiController.tabBarItem = .like
    falling.viewControllable.uiController.tabBarItem = .falling
    chat.viewControllable.uiController.tabBarItem = .chat
    myPage.viewControllable.uiController.tabBarItem = .myPage

    attachChild(falling)
    attachChild(like)
    attachChild(chat)
    attachChild(myPage)
  }

  func detachTab() {
    
  }
}
