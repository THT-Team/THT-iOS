
//
//  SignUpRootViewController.swift
//  Falling
//
//  Created by Hoo's MacBookPro on 2023/07/16.
//

import UIKit

import DSKit

import AuthInterface

final class AuthRootViewController: TFBaseViewController {
  private lazy var buttonStackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 16
  }

  private lazy var startPhoneBtn = TFLoginButton(btnType: .phone)

  private lazy var startKakaoButton = TFLoginButton(btnType: .kakao)

  private lazy var startGoogleBtn = TFLoginButton(btnType: .google)

  private lazy var startNaverBtn = TFLoginButton(btnType: .naver)

  private lazy var signitureImageView: UIImageView = UIImageView(image: DSKitAsset.Bx.signitureVertical.image).then {
    $0.contentMode = .scaleAspectFit
  }

  var viewModel: AuthRootViewModel!

  override func makeUI() {
    view.backgroundColor = DSKitAsset.Color.neutral700.color
    view.addSubview(signitureImageView)
    signitureImageView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(view.safeAreaLayoutGuide)
        .inset(view.bounds.height * 0.162)
      $0.height.equalTo(180)
    }
    
    signitureImageView.transform = CGAffineTransform(translationX: 0, y: 60)
    UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut) {
      self.signitureImageView.transform = .identity
    }

    self.view.addSubview(buttonStackView)
    self.buttonStackView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.leading.trailing.equalToSuperview().inset(40)
      $0.bottom.equalTo(view.safeAreaLayoutGuide)
        .inset(16)
    }

    [startPhoneBtn, startKakaoButton, startGoogleBtn, startNaverBtn]
      .forEach {
        buttonStackView.addArrangedSubview($0)
        $0.snp.makeConstraints { make in
          make.height.equalTo(52)
        }
      }
  }

  override func bindViewModel() {
    let buttonTap = Driver<SNSType>.merge(
      startPhoneBtn.rx.tap.asDriver().map { return SNSType.normal },
      startKakaoButton.rx.tap.asDriver().map { return SNSType.kakao },
      startGoogleBtn.rx.tap.asDriver().map { SNSType.google },
      startNaverBtn.rx.tap.asDriver().map { SNSType.naver }
    )

    let input = AuthRootViewModel.Input(
      buttonTap: buttonTap
    )

    let output = viewModel.transform(input: input)
  }
}
