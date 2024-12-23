//
//  MyPageAlertCoordinating.swift
//  MyPageInterface
//
//  Created by Kanghos on 6/15/24.
//

import Foundation

import Core

public typealias AlertHandler = (() -> Void)?

public protocol MyPageAlertCoordinating: Coordinator {
  var finishFlow: (() -> Void)? { get set }
  func showAlert(_ handler: AlertHandler, alertType: MyPageAlertType)
}

public enum MyPageAlertType {
  case logout
  case deactivate

  public var title: String {
    switch self {
    case .logout:
      "로그아웃하시겠어요?"
    case .deactivate:
      "계정 탈퇴하기"
    }
  }

  public var message: String? {
    switch self {
    case .logout:
      return nil
    case .deactivate:
      return "정말 탈퇴하시겠어요? 회원님의 모든 정보 및\n사용 내역은 복구 불가합니다. 관련 문의는\nteamtht23@gmail.com 으로 부탁드립니다."
    }
  }

  public var topActionTitle: String {
    switch self {
    case .logout:
      "확인"
    case .deactivate:
      "탈퇴하기"
    }
  }

  public var bottomActonTitle: String {
    return "취소"
  }
}
