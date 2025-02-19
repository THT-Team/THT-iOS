//
//  ChatRoomFactory.swift
//  ChatRoom
//
//  Created by Kanghos on 1/6/25.
//

import Foundation
import Core
import Domain

public final class ChatRoomFactory {

  private let talkUseCase: TalkUseCaseInterface
  private let userUseCase: UserDomainUseCaseInterface
  private let chatUseCase: ChatUseCaseInterface

  public init(
    talkUseCase: TalkUseCaseInterface,
    userUseCase: UserDomainUseCaseInterface,
    chatUseCase: ChatUseCaseInterface
  ) {
    self.talkUseCase = talkUseCase
    self.userUseCase = userUseCase
    self.chatUseCase = chatUseCase
  }

  public func makeChatRoom(_ id: String) -> (ViewControllable, ChatRoomReactor) {
    let rc = ChatRoomReactor(chatUseCase: chatUseCase, userUseCase: userUseCase, talkUseCase: talkUseCase, id: id)
    let vc = ChatRoomViewController(reactor: rc)
    return (vc, rc)
  }

  public func makeProfile(_ item: ProfileItem) -> (ViewControllable, ProfileReactor) {
    let rc = ProfileReactor(item: item, userUseCase: userUseCase)
    let vc = ProfileViewController(reactor: rc)
    vc.modalPresentationStyle = .fullScreen
    vc.modalTransitionStyle = .crossDissolve
    return (vc, rc)
  }
}
