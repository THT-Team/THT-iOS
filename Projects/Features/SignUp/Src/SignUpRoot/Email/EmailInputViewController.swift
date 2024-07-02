//
//  EmailInputViewController.swift
//  Falling
//
//  Created by Hoo's MacBookPro on 2023/08/06.
//

import UIKit

import DSKit

final class EmailInputViewController: BaseSignUpVC<EmailInputViewModel> {

  private lazy var titleLable: UILabel = UILabel().then {
    $0.text = "이메일 입력"
    $0.font = .thtH1B
    $0.textColor = DSKitAsset.Color.neutral50.color
  }

  private lazy var emailTextField = TFBaseField(placeholder: "welcome@falling.com").then {
    $0.textField.keyboardType = .emailAddress
  }

  private lazy var descriptionView = TFMultiLineDescriptionView(description: "이메일 계정 인증으로 로그인 문제가 생길 시 이메일로\n계정 복구를 진행합니다. 따로 프로필에 표시 되지 않습니다.")

  private lazy var autoDomainListView: UIStackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 8
    $0.alignment = .leading
  }

  private lazy var naverDomainBtn = EmailDomainBtn(emailDomain: .naver)
  private lazy var gmailDomainBtn = EmailDomainBtn(emailDomain: .gmail)
  private lazy var kakaoDomainBtn = EmailDomainBtn(emailDomain: .kakao)

  private lazy var nextButton = CTAButton(btnTitle: "다음",
                                          initialStatus: false)

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    emailTextField.becomeFirstResponder()
  }

  override func makeUI() {
    [
      titleLable,
      emailTextField,
      autoDomainListView,
      descriptionView,
      nextButton
    ].forEach { view.addSubview($0) }

    [naverDomainBtn, gmailDomainBtn, kakaoDomainBtn]
      .forEach { autoDomainListView.addArrangedSubview($0)
        $0.isHidden = true
      }

    titleLable.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(38.adjusted)
      $0.top.equalToSuperview().inset(184.adjustedH)
    }

    emailTextField.snp.makeConstraints {
      $0.leading.trailing.equalTo(titleLable)
      $0.top.equalTo(titleLable.snp.bottom).offset(32)
    }

    autoDomainListView.snp.makeConstraints {
      $0.leading.trailing.equalTo(titleLable).offset(4)
      $0.top.equalTo(emailTextField.snp.bottom)
    }

    descriptionView.snp.makeConstraints {
      $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(38.adjusted)
      $0.top.equalTo(autoDomainListView.snp.bottom)
    }

    nextButton.snp.makeConstraints {
      $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(38)
      $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-16)
      $0.height.equalTo(54)
    }
  }

  override func bindViewModel() {
    let emailTFStrDriver = emailTextField.rx.text.orEmpty.asDriver()

    emailTFStrDriver
      .drive(naverDomainBtn.rx.setTitle, gmailDomainBtn.rx.setTitle, kakaoDomainBtn.rx.setTitle)
      .disposed(by: disposeBag)

    let input = EmailInputViewModel.Input(
      viewDidAppear: rx.viewDidAppear.asDriver().map { _ in },
      emailText: emailTFStrDriver,
      nextBtnTap: nextButton.rx.tap.asDriver(),
      naverBtnTapped: naverDomainBtn.rx.tap.asDriver(),
      kakaoBtnTapped: kakaoDomainBtn.rx.tap.asDriver(),
      gmailBtnTapped: gmailDomainBtn.rx.tap.asDriver(),
      backButtonTap: backButton.rx.tap.asSignal()
    )

    let output = viewModel.transform(input: input)

    output.buttonState
      .drive(nextButton.rx.buttonStatus, nextButton.rx.isEnabled)
      .disposed(by: disposeBag)

    output.emailTextStatus
      .drive(with: self, onNext: { vc, state in
        switch state {
        case .empty, .valid:
          vc.autoDomainListView.arrangedSubviews.forEach { $0.isHidden = true }
        case .invalid:
          vc.emailTextField.send(action: TFBaseField.Action.error(message: "올바른 이메일 주소를 입력해주세요."))
          vc.autoDomainListView.arrangedSubviews.forEach { $0.isHidden = false }
        }
      })
      .disposed(by: disposeBag)

    output.emailText
      .drive(emailTextField.rx.text)
      .disposed(by: disposeBag)
  }
}
