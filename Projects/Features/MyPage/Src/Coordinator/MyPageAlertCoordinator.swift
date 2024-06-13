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
  public var delegate: MyPageAlertCoordinatorDelegate?

  public override func start() {

  }
}

extension MyPageAlertCoordinator: MyPageAlertCoordinating {
  public func showLogoutAlert(listener: LogoutListenr) {
    self.viewControllable.uiController.showAlert(
      title: "로그아웃하시겠어요?",
      topActionTitle: "로그아웃",
      bottomActionTitle: "취소",
      dimColor: DSKitAsset.Color.DimColor.default.color,
      topActionCompletion: {
        listener.logoutTap()
      },
      bottomActionCompletion: { [weak self] in
        self?.delegate?.detachMyPageAlert()
      }
    )
  }

  public func showDeactivateAlert(listener: DeactivateListener) {
    self.viewControllable.uiController.showAlert(
      title: "계정 탈퇴하기",
      message: "정말 탈퇴하시겠어요? 회원님의 모든 정보 및\n사용 내역은 복구 불가합니다. 관련 문의는\nteamtht23@gmail.com 으로 부탁드립니다.",
      topActionTitle: "탈퇴하기",
      bottomActionTitle: "취소",
      dimColor: DSKitAsset.Color.DimColor.pauseDim.color,
      topActionCompletion: {
        listener.deactivateTap()
      },
      bottomActionCompletion: { [weak self] in
        self?.delegate?.detachMyPageAlert()
      }
    )
  }
}
