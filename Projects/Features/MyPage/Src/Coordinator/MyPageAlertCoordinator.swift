//
//  MyPageAlertCoordinator.swift
//  MyPageInterface
//
//  Created by Kanghos on 6/15/24.
//

import Foundation
import MyPageInterface

import Core
import DSKit

public final class MyPageAlertCoordinator: BaseCoordinator {
  public var finishFlow: (() -> Void)?
}

extension MyPageAlertCoordinator: MyPageAlertCoordinating {

  public func showAlert(_ handler: AlertHandler, alertType: MyPageAlertType) {
    self.viewControllable.uiController.showAlert(
      title: alertType.title,
      message: alertType.message,
      topActionTitle: alertType.topActionTitle,
      bottomActionTitle: alertType.bottomActonTitle,
      dimColor: alertType == .logout
      ? DSKitAsset.Color.DimColor.default.color
      : DSKitAsset.Color.DimColor.pauseDim.color) { [weak self] in
        handler?()
        self?.finishFlow?()
      } bottomActionCompletion: { [weak self] in
        self?.finishFlow?()
      } dimActionCompletion: { [weak self] in
        self?.finishFlow?()
      }
  }
}
