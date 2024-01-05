//
//  LoginButton.swift
//  Falling
//
//  Created by Hoo's MacBookPro on 2023/07/22.
//

import UIKit

import Core

enum TFLoginButtonType {
  case phone
  case kakao
  case google
  case naver

  var title: String {
    switch self {
    case .phone:
      return "핸드폰 번호로 시작하기"
    case .kakao:
      return "카카오톡으로 시작하기"
    case .google:
      return "구글로 시작하기"
    case .naver:
      return "네이버로 시작하기"
    }
  }

  var backGroundColor: UIColor {
    switch self {
    case .phone:
      return DSKitAsset.Color.neutral900.color
    case .kakao:
      return .yellow
//      return .kakaoPrimary
    case .google:
      return DSKitAsset.Color.neutral50.color
    case .naver:
      return .blue
//      return .naverPrimary
    }
  }

  var titleColor: UIColor {
    switch self {
    case .phone, .naver:
      return DSKitAsset.Color.neutral50.color
    case .kakao, .google:
      return DSKitAsset.Color.neutral900.color
    }
  }

//  var icon: UIImage {
//    switch self {
//    case .phone:
//      return Icon.Profile.pin
//    case .kakao:
//      return Icon.Profile.pin
//    case .google:
//      return Icon.Profile.pin
//    case .naver:
//      return Icon.Profile.pin
//    }
//  }
}

final class TFLoginButton: UIButton {
  let btnType: TFLoginButtonType

  init(btnType: TFLoginButtonType) {
    self.btnType = btnType
    super.init(frame: .zero)

    setTitle(btnType.title, for: .normal)
//    setImage(btnType.icon, for: .normal)
    setTitleColor(btnType.titleColor, for: .normal)
    backgroundColor = btnType.backGroundColor
    titleLabel?.font = .thtSubTitle1Sb
    imageEdgeInsets.right = 52
    layer.cornerRadius = 26
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
