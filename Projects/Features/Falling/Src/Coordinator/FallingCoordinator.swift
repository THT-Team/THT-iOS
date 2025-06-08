//
//  FallingCoordinator.swift
//  FallingInterface
//
//  Created by SeungMin on 1/11/24.
//

import Foundation

import FallingInterface
import Core

import DSKit
import ChatRoomInterface
import Domain

protocol TopicActionDelegate: AnyObject {
  func didTapStartButton(topic: DailyKeyword)
  func didFinishDailyTopic()
}

public final class FallingCoordinator: BaseCoordinator, FallingCoordinating {
  @Injected var topicUseCase: TopicUseCaseInterface
  @Injected var fallingUseCase: FallingUseCaseInterface

  private let chatRoomBuilder: ChatRoomBuildable

  public init(chatRoomBuilder: ChatRoomBuildable, viewControllable: ViewControllable) {
    self.chatRoomBuilder = chatRoomBuilder
    super.init(viewControllable: viewControllable)
  }

  public override func start() {
    homeFlow()
  }

  public func homeFlow() {
    let viewModel = FallingViewModel(topicUseCase: topicUseCase, fallingUseCase: fallingUseCase)

    viewModel.onReport = { [weak viewControllable] handler in
      guard let viewControllable else { return }
      AlertHelper.userReportAlert(viewControllable, handler)
    }

    viewModel.onMatch = { [weak self] url, index in
      self?.toMatchFlow(url, index: index)
    }

    let viewController = FallingViewController(viewModel: viewModel)

    self.viewControllable.setViewControllers([viewController])
  }

  public func chatRoomFlow(_ index: String) {
        TFLogger.dataLogger.info("ChatRoom!")
    let coordinator = chatRoomBuilder.build(rootViewControllable: viewControllable)

    coordinator.finishFlow = { [weak self, weak coordinator] message in
      guard let self, let coordinator else { return }
      coordinator.childCoordinators.removeAll()
      self.detachChild(coordinator)
    }
    attachChild(coordinator)
    coordinator.chatRoomFlow(index)
  }

  public func toMatchFlow(_ imageURL: String, index: String) {
    let vc = MatchViewController(imageURL, index: index)

    vc.onCancel = { [weak self] in
      self?.viewControllable.dismiss()
    }

    vc.onClick = { [weak self] index in
      self?.viewControllable.dismiss()
      self?.chatRoomFlow(index)
    }

    vc.uiController.modalTransitionStyle = .crossDissolve
    vc.uiController.modalPresentationStyle = .overFullScreen
    viewControllable.present(vc, animated: true)
  }
}
