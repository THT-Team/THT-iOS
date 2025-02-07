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

  init() {
  }

  func build(talkUseCase: TalkUseCaseInterface) -> MainCoordinating {
    let tabBar = TFTabBarController()
    let chatRoomBuilder = ChatRoomBuilder(talkUseCase: talkUseCase)
    let fallingBuilder = FallingBuilder(chatRoomBuilder: chatRoomBuilder)
    let likeBuilder = LikeBuilder(chatRoomBuilder: chatRoomBuilder)
    let chatBuilder = ChatBuilder(chatRoomBuilder: chatRoomBuilder)
    let myPageBuilder = MyPageBuilder(factory: MyPageFactory(userStore: UserStore(), inquiryBuilder: InquiryBuilder()))

    let coordinator = MainCoordinator(
      viewControllable: tabBar,
      fallingBuildable: fallingBuilder,
      likeBuildable: likeBuilder,
      chatBuildable: chatBuilder,
      myPageBuildable: myPageBuilder
    )

    return coordinator
  }
}
