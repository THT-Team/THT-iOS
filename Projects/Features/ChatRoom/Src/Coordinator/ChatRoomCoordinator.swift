//
//  ChatRoomCoordinator.swift
//  ChatRoom
//
//  Created by Kanghos on 1/6/25.
//

import UIKit
import Core
import Domain
import DSKit
import ChatRoomInterface

public final class ChatRoomCoordinator: BaseCoordinator, ChatRoomCoordinating {
  
  private let factory: ChatRoomFactory

  public var finishFlow: ((String?) -> Void)?

  public init(factory: ChatRoomFactory, _ rootViewController: ViewControllable) {
    self.factory = factory
    super.init(viewControllable: rootViewController)
  }

  public override func start() {
    (self.viewControllable.uiController as? UINavigationController)?.delegate = TransitionManager.shared
  }

  public func chatRoomFlow(_ id: String) {
    let (vc, vm) = factory.makeChatRoom(id)

    vm.onBack = { [weak self] message in
      self?.viewControllable.popViewController(animated: true)
      self?.finishFlow?(message)
    }

    vm.onExit = { [weak self] handler in
      guard let self else { return }
      AlertHelper.makeExitAlert(viewControllable, handler: handler)
    }

    vm.onReport = { [weak viewControllable] handler in
      guard let viewControllable else { return }
      AlertHelper.userReportAlert(viewControllable, handler)
    }

    vm.onProfile = { [weak self] item, handler in
      guard let self else { return }
      self.profileFlow(item, handler)
    }

    viewControllable.pushViewController(vc, animated: true)
  }

  public func profileFlow(_ item: ProfileItem, _ handler: ProfileOutputHandler?) {
    TransitionManager.shared.modalTransition = nil

    let (vc, vm) = factory.makeProfile(item)

    vm.onReport = { [weak viewControllable] handelr in
      guard let viewControllable else { return }
      AlertHelper.userReportAlert(viewControllable, handelr)
    }

    vm.onDismiss = { [weak self] need in
      TransitionManager.shared.modalTransition = need
      ? RotatateTransition() : nil
      self?.viewControllable.dismiss()
    }

    vm.handler = handler
    vc.uiController.transitioningDelegate = TransitionManager.shared
    viewControllable.present(vc, animated: true)
  }
}

extension AlertHelper {
  static func makeExitAlert(
    _ viewController: ViewControllable,
    handler: ConfirmHandler?
  ) {
    let alert = makeExitAlert {
      handler?(.confirm)
    } cancelAction: {
      handler?(.cancel)
    }
    viewController.present(alert, animated: true)
  }
  static func makeExitAlert(
    topAction: (() -> Void)?,
    cancelAction: (() -> Void)?
  ) -> ViewControllable {
    let alert = TFAlertViewController(
      titleText: "채팅을 종료할까요?",
      messageText: "더 이상 채팅을 이어갈 수 없어요."
    )

    alert.addActionToButton(title: "나가기") { [weak alert] in
      alert?.dismiss(animated: false) {
        topAction?()
      }
    }

    alert.addActionToButton(title: "취소", withSeparator: true) { [weak alert] in
      alert?.dismiss(animated: false) {
        cancelAction?()
      }
    }

    alert.addActionToDim { [weak alert] in
      alert?.dismiss(animated: false) {
        cancelAction?()
      }
    }
    alert.modalTransitionStyle = .crossDissolve
    return alert
  }
}
