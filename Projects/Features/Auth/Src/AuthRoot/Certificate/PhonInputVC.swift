//
//  PhonInputVC.swift
//  Auth
//
//  Created by kangho lee on 7/26/24.
//

import UIKit

import AuthInterface
import DSKit

public final class PhoneInputVC: TFBaseViewController, PhoneNumberVCType {
  public typealias ViewModel = PhoneInputVM

  private lazy var titleLabel: UILabel = UILabel().then {
    $0.text = "핸드폰 번호 인증"
    $0.font = .thtH1B
    $0.textColor = DSKitAsset.Color.neutral50.color
  }
  
  private lazy var phoneNumField = TFTextField(description: "핸드폰 번호 입력 시, 인증 코드를 문자 메세지로 발송합니다.\n핸드폰 번호는 다른 사람들에게 공유되거나 프로필에 표시하지 않습니다.", placeholder: "01012345678").then {
    $0.textField.textField.keyboardType = .numberPad
    $0.textField.tintColor = .clear
  }

  private lazy var verifyBtn = CTAButton(btnTitle: "인증하기", initialStatus: false)

  private let viewModel: ViewModel

  public init(viewModel: ViewModel) {
    self.viewModel = viewModel
    super.init()
  }

  let headerView = UIView()

  public override func makeUI() {
    self.view.backgroundColor = DSKitAsset.Color.neutral700.color
    
    [headerView, titleLabel, phoneNumField, verifyBtn].forEach {
      self.view.addSubview($0)
    }

    headerView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.top.equalTo(self.view.safeAreaLayoutGuide)
      $0.height.equalTo(56.adjustedH)
    }

    titleLabel.snp.makeConstraints {
      $0.top.equalTo(headerView.snp.bottom).offset(76.adjustedH)
      $0.leading.trailing.equalToSuperview().inset(38.adjusted)
    }

    phoneNumField.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(32.adjustedH)
      $0.leading.trailing.equalTo(titleLabel)
    }

    verifyBtn.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(38.adjusted)
      $0.bottom.equalTo(self.view.keyboardLayoutGuide.snp.top).offset(-14)
      $0.height.equalTo(54.adjustedH)
    }
  }

  public override func navigationSetting() {
    navigationController?.setNavigationBarHidden(true, animated: false)
    setBackButton()
  }

  public override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    phoneNumField.becomeFirstResponder()
  }

  public override func bindViewModel() {
    let input = ViewModel.Input(
      phoneNum: phoneNumField.rx.text.orEmpty.asDriver(),
      verifyBtn: verifyBtn.rx.tap.withLatestFrom(phoneNumField.rx.text.orEmpty)
        .asDriver(onErrorJustReturn: "")
    )
    
    let output = viewModel.transform(input: input)
    
    output.validate
      .drive(verifyBtn.rx.buttonStatus)
      .disposed(by: disposeBag)
    
    output.validate
      .map { $0 == true }
      .drive(verifyBtn.rx.isEnabled)
      .disposed(by: disposeBag)

    output.initialValue
      .drive(phoneNumField.rx.text)
      .disposed(by: disposeBag)
  }
}
