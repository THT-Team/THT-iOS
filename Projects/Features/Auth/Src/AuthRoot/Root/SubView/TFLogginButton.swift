//
//  LoginButton.swift
//  Falling
//
//  Created by Hoo's MacBookPro on 2023/07/22.
//

import UIKit

import DSKit
import Core

enum TFLoginButtonType {
  case phone
  case kakao
  case google
  case naver
  case apple

  var title: String {
    switch self {
    case .phone:
      return "핸드폰 번호로 시작하기"
    case .kakao:
      return "카카오톡으로 시작하기"
    case .google:
      return "Google로 시작하기"
    case .naver:
      return "네이버로 시작하기"
    case .apple:
      return "Apple로 시작하기"
    }
  }

  var backGroundColor: UIColor {
    switch self {
    case .phone:
      return DSKitAsset.Color.neutral900.color
    case .kakao:
      return DSKitAsset.Color.kakaoPrimary.color
    case .google:
      return DSKitAsset.Color.neutral50.color
    case .naver:
      return DSKitAsset.Color.naverPrimary.color
    case .apple:
      return DSKitAsset.Color.neutral50.color
    }
  }

  var titleColor: UIColor {
    switch self {
    case .phone, .naver:
      return DSKitAsset.Color.neutral50.color
    case .kakao, .google, .apple:
      return DSKitAsset.Color.neutral900.color
    }
  }

  var icon: UIImage {
    switch self {
    case .phone:
      return DSKitAsset.Image.phone.image
    case .kakao:
      return DSKitAsset.Image.kakaotalk.image
    case .google:
      return DSKitAsset.Image.google.image
    case .naver:
      return DSKitAsset.Image.naver.image
    case .apple:
      return DSKitAsset.Image.apple.image
    }
  }
}

final class TFLoginButton: UIButton {
  let btnType: TFLoginButtonType

  init(btnType: TFLoginButtonType) {
    self.btnType = btnType
    super.init(frame: .zero)

    setTitle(btnType.title, for: .normal)
    setImage(btnType.icon, for: .normal)
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

public final class TFSNSLoginButton: UIControl {
  let btnType: TFLoginButtonType

  public private(set) lazy var imageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
    $0.image = btnType.icon
  }
  public private(set) lazy var titleLabel = UILabel().then {
    $0.font = .thtSubTitle1Sb
    $0.text = btnType.title
    $0.textColor = btnType.titleColor
    $0.textAlignment = .center
  }

  init(btnType: TFLoginButtonType) {
    self.btnType = btnType
    super.init(frame: .zero)
    makeUI()
    self.addAction(.init { _ in
      HapticFeedbackManager.shared.triggerImpactFeedback(style: .medium)
    }, for: .touchUpInside)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override var isHighlighted: Bool {
    didSet {
      if isHighlighted {
        UIView.animate(withDuration: 0.1) {
          self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
          self.backgroundColor = self.btnType.backGroundColor.adjusted(brightness: 1.2)
        }
      } else {
        UIView.animate(withDuration: 0.1) {
          self.transform = .identity
          self.backgroundColor = self.btnType.backGroundColor
        }
      }
    }
  }

  func makeUI() {
    layer.cornerRadius = 26
    layer.masksToBounds = true
    backgroundColor = btnType.backGroundColor

    addSubviews(imageView, titleLabel)
    
    imageView.snp.makeConstraints {
      $0.size.equalTo(22)
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview().offset(20)
    }

    titleLabel.snp.makeConstraints {
      $0.leading.equalTo(imageView.snp.trailing)
      $0.trailing.equalToSuperview().offset(-10)
      $0.top.bottom.equalToSuperview().inset(10)
    }
  }
}

extension Reactive where Base: TFSNSLoginButton {
  var tap: ControlEvent<Void> {
      controlEvent(.touchUpInside)
  }
}
