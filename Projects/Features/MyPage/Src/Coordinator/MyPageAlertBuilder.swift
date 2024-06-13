//
//  MyPageAlertBuilder.swift
//  MyPage
//
//  Created by Kanghos on 6/13/24.
//

import Foundation
import DSKit
import MyPageInterface

final class MyPageAlertBuilder {
  private var viewControllable: ViewControllable?

  public init(viewControllable: ViewControllable?) {
    self.viewControllable = viewControllable
  }

  func buildLogoutAlert(listener: LogoutListenr) {
    self.viewControllable?.uiController.showAlert(
      title: "로그아웃하시겠어요?",
      topActionTitle: "로그아웃",
      bottomActionTitle: "취소", 
      dimColor: DSKitAsset.Color.clear.color,
      topActionCompletion: {
        listener.logoutTap()
      }
    )
  }

  func buildDeactivateAlert(listener: DeactivateListener) {
    self.viewControllable?.uiController.showAlert(
      title: "계정 탈퇴하기",
      message: """
정말 탈퇴하시겠어요? 회원님의 모든 정보 및
      사용 내역은 복구 불가합니다. 관련 문의는
      teamtht23@gmail.com 으로 부탁드립니다.
""",
      topActionTitle: "탈퇴하기",
      bottomActionTitle: "취소",
      dimColor: DSKitAsset.Color.clear.color,
      topActionCompletion: {
        listener.deactivateTap()
      }
    )
  }
}
