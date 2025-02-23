
//
//  SignUpRootViewController.swift
//  Falling
//
//  Created by Hoo's MacBookPro on 2023/07/16.
//

import UIKit

import DSKit

import AuthInterface
import Domain

final class AuthRootViewController: TFBaseViewController {
  private lazy var buttonStackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 16
  }

  private lazy var startPhoneBtn = TFSNSLoginButton(btnType: .phone)

  private lazy var startKakaoButton = TFSNSLoginButton(btnType: .kakao)

  private lazy var startGoogleBtn = TFSNSLoginButton(btnType: .google)

  private lazy var startAppleBtn = TFSNSLoginButton(btnType: .apple)

  private lazy var startNaverBtn = TFSNSLoginButton(btnType: .naver)

  private lazy var feedbackBtn = DSKit.TFTextButton(title: "계정에 문제가 있나요?")

  private lazy var signitureImageView: UIImageView = UIImageView(image: DSKitAsset.Bx.signitureVertical.image).then {
    $0.contentMode = .scaleAspectFit
  }

  var viewModel: AuthRootViewModel!

  override func makeUI() {
    let scrollView = UIScrollView()
    scrollView.showsVerticalScrollIndicator = false
    scrollView.backgroundColor = DSKitAsset.Color.neutral700.color
    view.addSubview(scrollView)

    scrollView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    let container = UIView()
    scrollView.addSubview(container)

    container.snp.makeConstraints {
      $0.verticalEdges.equalTo(scrollView.contentLayoutGuide)
      $0.horizontalEdges.equalTo(scrollView.frameLayoutGuide)
    }

    container.addSubview(signitureImageView)
    signitureImageView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(container).inset(181.adjustedH).priority(199)
      $0.height.equalTo(180)
    }
    
    signitureImageView.transform = CGAffineTransform(translationX: 0, y: 60)

    container.addSubview(buttonStackView)
    self.buttonStackView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.leading.trailing.equalToSuperview().inset(40)
      $0.top.equalTo(signitureImageView.snp.bottom).offset(50).priority(.low)
      $0.bottom.equalTo(container).offset(-20)
    }

    [startPhoneBtn, startKakaoButton, startAppleBtn,
//     startGoogleBtn, startNaverBtn,
    ]
      .forEach {
        buttonStackView.addArrangedSubview($0)
        $0.snp.makeConstraints { make in
          make.height.equalTo(52)
        }
      }
    feedbackBtn.makeView(title: "계정에 문제가 있나요?", color: DSKitAsset.Color.neutral50.color)
    buttonStackView.addArrangedSubview(feedbackBtn)
    
    feedbackBtn.snp.makeConstraints {
      $0.height.equalTo(30)
    }
  }

  override func bindViewModel() {
    let buttonTap = Driver<SNSType>.merge(
      startPhoneBtn.rx.tap.asDriver().map { return SNSType.normal },
      startKakaoButton.rx.tap.asDriver().map { return SNSType.kakao },
      startGoogleBtn.rx.tap.asDriver().map { SNSType.google },
      startNaverBtn.rx.tap.asDriver().map { SNSType.naver },
      startAppleBtn.rx.tap.asDriver().map { SNSType.apple }
    )

    let input = AuthRootViewModel.Input(
      buttonTap: buttonTap,
      inquiryTap: feedbackBtn.rx.tap.asSignal()
    )

    let _ = viewModel.transform(input: input)
  }

  override func navigationSetting() {
    super.navigationSetting()

    self.navigationController?.setNavigationBarHidden(true, animated: true)
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut) {
      self.signitureImageView.transform = .identity
    }
  }
}
