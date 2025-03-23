//
//  AppCoordinator.swift
//  ChatRoom
//
//  Created by Kanghos on 1/20/25.
//

import UIKit
import DSKit
import Core
import ChatRoomInterface
import ChatRoom
import Domain

final class AppCoordinator: LaunchCoordinator {
  private let chatRoomBuilder: ChatRoomBuildable
  private let talkLifeCycleUseCase: TalkUseCaseInterface

  private var toastHandler: ((String?) -> Void)?

  init(
    viewControllable: ViewControllable,
    chatRoomBuildable: ChatRoomBuildable
  ) {
    self.chatRoomBuilder = chatRoomBuildable
    self.talkLifeCycleUseCase =  MockTalkUseCase()
    super.init(viewControllable: viewControllable)
  }

  public override func start() {

//    viewControllable.pushViewController(vc, animated: true)
  }

  // MARK: - public
  func runChatRoomFlow(_ id: String) {
    var coordinator = self.chatRoomBuilder.build(rootViewControllable: viewControllable)

    coordinator.finishFlow = { [weak self, weak coordinator] message in
      guard let coordinator else { return }
      guard let self else { return }
      self.toastHandler?(message)
      self.detachChild(coordinator)
    }

    attachChild(coordinator)
    coordinator.chatRoomFlow(id)
  }
}
