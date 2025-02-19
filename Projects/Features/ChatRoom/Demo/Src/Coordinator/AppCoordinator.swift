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
import ChatInterface
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
    let vc = SimpleVC(nibName: nil, bundle: nil)
    vc.onClick = { [weak self] in
      self?.runChatRoomFlow("1")
    }

    self.toastHandler = { [weak vc] message in
      vc?.toastHandler?(message)
    }

    viewControllable.pushViewController(vc, animated: true)
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


final class SimpleVC: TFBaseViewController {
  var onClick: (() -> Void)?
  var toastHandler: ((String?) -> Void)?

  var mainView = TFBaseView()

  override func loadView() {
    self.view = mainView

    let button = UIButton()
    button.setTitle("버튼", for: .normal)

    self.view.addSubview(button)
    button.snp.makeConstraints {
      $0.width.equalTo(100)
      $0.height.equalTo(60)
      $0.center.equalToSuperview()
    }

    button.addAction(UIAction { [weak self] _ in
      self?.onClick?()
    }, for: .touchUpInside)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.toastHandler = { [weak self] message in
      self?.mainView.makeToast(message)
    }
  }

  func makeToast(_ message: String?) {
    self.mainView.makeToast(message)
  }
}
