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

public final class FallingCoordinator: BaseCoordinator, FallingCoordinating {
  @Injected var fallingUseCase: FallingUseCaseInterface

  public weak var delegate: FallingCoordinatorDelegate?

  public override func start() {
    homeFlow()
  }

  public func homeFlow() {
    let viewModel = FallingHomeViewModel(fallingUseCase: fallingUseCase)
    viewModel.delegate = self

    let viewController = FallingHomeViewController(viewModel: viewModel)

    self.viewControllable.setViewControllers([viewController])
  }

  public func chatRoomFlow() {
        TFLogger.dataLogger.info("ChatRoom!")
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

extension FallingCoordinator: FallingHomeActionDelegate {
  public func invoke(_ action: FallingHomeNavigationAction) {
    switch action {
    case let .toReportBlockAlert(listener):
      reportOrBlockAlert(listener)
    case let .toReportAlert(listener):
      userReportAlert(listener)
    case let .toBlockAlert(listener):
      blockAlertFlow(listener)
    case let .toChatRoom(chatRoomIndex):
      chatRoomFlow()
    }
  }
}
