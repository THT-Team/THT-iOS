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

public final class FallingCoordinator: BaseCoordinator, FallingCoordinating {
  
  @Injected var fallingUseCase: FallingUseCaseInterface
  private let chatRoomBuilder: ChatRoomBuildable

  public weak var delegate: FallingCoordinatorDelegate?

  public init(chatRoomBuilder: ChatRoomBuildable, viewControllable: ViewControllable) {
    self.chatRoomBuilder = chatRoomBuilder
    super.init(viewControllable: viewControllable)
  }

  public override func start() {
    homeFlow()
  }

  public func homeFlow() {
    let viewModel = FallingViewModel(fallingUseCase: fallingUseCase)
    viewModel.delegate = self

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

  public func matchFlow(_ imageURL: String, index: String) {
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

extension FallingCoordinator: FallingAlertCoordinating {
  public func reportOrBlockAlert(_ listener: BlockOrReportAlertListener) {
    let alert = TFAlertBuilder.makeBlockOrReportAlert(listener: listener)

    self.viewControllable.present(alert, animated: false)
  }

  public func blockAlertFlow(_ listener: BlockAlertListener) {
    let alert = TFAlertBuilder.makeBlockAlert(listener: listener)

    self.viewControllable.present(alert, animated: false)
  }

  public func userReportAlert(_ listener: ReportAlertListener) {
    let alert = TFAlertBuilder.makeUserReportAlert(listener: listener)
    self.viewControllable.present(alert, animated: false)
  }
}

extension FallingCoordinator: FallingActionDelegate {
  public func invoke(_ action: FallingNavigationAction) {
    switch action {
    case let .toReportBlockAlert(listener):
      reportOrBlockAlert(listener)
    case let .toReportAlert(listener):
      userReportAlert(listener)
    case let .toBlockAlert(listener):
      blockAlertFlow(listener)
    case let .matchFlow(url, index):
      matchFlow(url, index: index)
    }
  }
}
