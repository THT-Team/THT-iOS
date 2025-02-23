//
//  MainBuilder.swift
//  Feature
//
//  Created by Kanghos on 2023/12/06.
//

import UIKit
import Core

import FallingInterface
import Falling

import LikeInterface
import Like

import ChatInterface
import Chat

import MyPageInterface
import MyPage

import Auth
import AuthInterface

import ChatRoom
import ChatRoomInterface

import Domain

final class MainBuilder: MainBuildable {
  @Injected var talkUseCase: TalkUseCaseInterface
  @Injected var myPageUseCase: MyPageUseCaseInterface
  @Injected var chatUseCase: ChatUseCaseInterface
  @Injected var likeUseCase: LikeUseCaseInterface
  @Injected var userdomainUseCase: UserDomainUseCaseInterface
  @Injected var locationUseCase: LocationUseCaseInterface

  init() { }

  func build() -> MainCoordinating {

    let root = TFTabBarController()

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
    like.viewControllable.uiController.tabBarItem = .like

    let falling = FallingBuilder(chatRoomBuilder: chatRoomBuilder)
      .build(rootViewControllable: NavigationViewControllable())
    falling.viewControllable.uiController.tabBarItem = .falling

    let chat = ChatBuilder(
      chatRoomBuilder: chatRoomBuilder,
      factory: ChatFactory(chatRoomBuilder: chatRoomBuilder, chatUseCase: chatUseCase))
      .build(rootViewControllable: NavigationViewControllable())
    chat.viewControllable.uiController.tabBarItem = .chat

    let myPage = MyPageBuilder(
      factory: MyPageFactory(
        userStore: UserStore(myPageUseCase),
        myPageUseCase: myPageUseCase,
        userDomainUseCase: userdomainUseCase,
        locationUseCase: locationUseCase,
        inquiryBuilder: InquiryBuilder())
    ).build(rootViewControllable: NavigationViewControllable())
    myPage.viewControllable.uiController.tabBarItem = .myPage

    root.setViewControllers([
      falling,
      like,
      chat,
      myPage
    ].map(\.viewControllable))

    let coordinator = MainCoordinator(viewControllable: root)
    coordinator.attachChild(falling)
    coordinator.attachChild(like)
    coordinator.attachChild(chat)
    coordinator.attachChild(myPage)

    return coordinator
  }
}
