
//
//  SignUpRootViewController.swift
//  Falling
//
//  Created by Hoo's MacBookPro on 2023/07/16.
//

import UIKit

import RxSwift
import RxKeyboard
import Core
import Then

final class SignUpRootViewController: TFBaseViewController {
  private lazy var buttonStackView: UIStackView = UIStackView().then {
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

  var viewModel: SignUpRootViewModel!

  override func viewDidLoad() {
    super.viewDidLoad()
    setupAccessibilityIdentifier()
  }

  override func makeUI() {
    view.addSubview(signitureImageView)
    signitureImageView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(view.safeAreaLayoutGuide)
        .inset(view.bounds.height * 0.162)
      $0.height.equalTo(180)
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
    let input = SignUpRootViewModel.Input(
      phoneBtn: startPhoneBtn.rx.tap.asDriver(),
      kakaoBtn: startKakaoButton.rx.tap.asDriver(),
      googleBtn: startGoogleBtn.rx.tap.asDriver(),
      naverBtn: startNaverBtn.rx.tap.asDriver()
    )

    let output = viewModel.transform(input: input)
  }
}

extension SignUpRootViewController {

  private func setupAccessibilityIdentifier() {
    startPhoneBtn.accessibilityIdentifier = AccessibilityIdentifier.phoneBtn
    startKakaoButton.accessibilityIdentifier = AccessibilityIdentifier.kakoBtn
    startNaverBtn.accessibilityIdentifier = AccessibilityIdentifier.naverBtn
    startGoogleBtn.accessibilityIdentifier = AccessibilityIdentifier.googleBtn
  }
}

//struct SignUpRootViewControllerPreview: PreviewProvider {
//  static var previews: some View {
//    SignUpRootViewController(viewModel: SignUpRootViewModel(navigator: SignUpNavigator(controller: UINavigationController()))).toPreView()
//  }
//}
