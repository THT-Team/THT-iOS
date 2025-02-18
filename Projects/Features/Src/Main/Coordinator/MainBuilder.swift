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

  func build(_ root: MainViewControllable) -> MainCoordinating {
    let chatRoomBuilder = ChatRoomBuilder(ChatRoomFactory(
      talkUseCase: talkUseCase,
      userUseCase: userdomainUseCase,
      chatUseCase: chatUseCase))

    let likeBuilder = LikeBuilder(
      chatRoomBuilder: chatRoomBuilder,
      factory: LikeFactory(chatRoomBuilder: chatRoomBuilder, userUseCase: userdomainUseCase))

    let fallingBuilder = FallingBuilder(chatRoomBuilder: chatRoomBuilder)

    let chatBuilder = ChatBuilder(
      chatRoomBuilder: chatRoomBuilder,
      factory: ChatFactory(chatRoomBuilder: chatRoomBuilder, chatUseCase: chatUseCase))

    let myPageBuilder = MyPageBuilder(
      factory: MyPageFactory(
        userStore: UserStore(myPageUseCase),
        myPageUseCase: myPageUseCase,
        userDomainUseCase: userdomainUseCase,
        locationUseCase: locationUseCase,
        inquiryBuilder: InquiryBuilder()))

    let coordinator = MainCoordinator(
      viewControllable: root,
      fallingBuildable: fallingBuilder,
      likeBuildable: likeBuilder,
      chatBuildable: chatBuilder,
      myPageBuildable: myPageBuilder
    )

    return coordinator
  }
}
