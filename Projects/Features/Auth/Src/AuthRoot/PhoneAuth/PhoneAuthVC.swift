//
//  PhoneAuthVC.swift
//  Auth
//
//  Created by kangho lee on 7/26/24.
//

import UIKit

import DSKit
import AuthInterface

public final class PhoneAuthVC<ViewModel>: TFBaseViewController, AuthVCType where ViewModel: AuthViewModelType {

  private lazy var codeInputView = UIView().then {
    $0.backgroundColor = DSKitAsset.Color.neutral700.color
  }

  private(set) lazy var blurView: UIVisualEffectView = {
    let effect = UIBlurEffect(style: .dark)
    let visualEffectView = UIVisualEffectView(effect: effect)
    visualEffectView.alpha = 0
    return visualEffectView
  }()

  private lazy var titleLabel = UILabel().then {
    $0.text = "인증 코드 입력"
    $0.font = .thtH1B
    $0.textColor = DSKitAsset.Color.neutral50.color
  }

  private lazy var codeInputDescLabel = UILabel().then {
    $0.numberOfLines = 2
    $0.font = .thtSubTitle1R
    $0.textColor = DSKitAsset.Color.neutral400.color
  }

  private lazy var timerLabel = UILabel().then {
    $0.text = "00:00"
    $0.font = .thtSubTitle1R
    $0.textColor = DSKitAsset.Color.error.color
  }

  private lazy var codeInputTextField = TFPinField().then {
    $0.updateAppearance { style in
      style.textColor = DSKitAsset.Color.primary500.color
      style.font = UIFont(name: "Menlo-Bold", size: 30)!//UIFont.thtH1B
      style.backActiveColor = DSKitAsset.Color.primary500.color
      style.backBorderColor = DSKitAsset.Color.neutral300.color
      style.backFocusColor = DSKitAsset.Color.neutral300.color
      
      style.tokenFocusColor = .clear

      style.tokenColor = .clear
      style.backColor = DSKitAsset.Color.neutral300.color
      style.backBorderWidth = 0
      style.kerning = 35
      style.backOffset = 15
    }

    $0.autocorrectionType = .no
    $0.spellCheckingType = .no
    $0.text = ""
  }

  private lazy var codeInputErrDesc = UILabel().then {
    $0.isHidden = true
    $0.font = .thtCaption1R
    $0.text = "인증 코드를 다시 확인 해 주세요."
    $0.textColor = DSKitAsset.Color.error.color
  }

  private lazy var resendButton = TFTextButton(title: "인증 코드 다시 받기")

  private lazy var successPopup = SuccessCertificationView().then {
    $0.isHidden = true
  }

  private let viewModel: ViewModel

  public init(viewModel: ViewModel) {
    self.viewModel = viewModel
    super.init()
  }

  public override func navigationSetting() {
    navigationController?.setNavigationBarHidden(true, animated: false)
    setBackButton()
  }

  public override func makeUI() {
    [codeInputView, blurView, successPopup].forEach {
      view.addSubview($0)
    }

    [titleLabel, codeInputDescLabel,
     timerLabel, codeInputTextField,
     resendButton, codeInputErrDesc]
      .forEach { codeInputView.addSubview($0) }
    
    codeInputTextField.updateProperties { properties in
      properties.keyboardType = UIKeyboardType.numberPad
    }

    codeInputView.snp.makeConstraints {
      $0.top.bottom.equalTo(view.safeAreaLayoutGuide).offset(56.adjustedH)
      $0.leading.trailing.equalToSuperview()
    }

    successPopup.snp.makeConstraints {
      $0.center.equalToSuperview()
      $0.width.equalTo(310.adjusted)
      $0.height.equalTo(450.adjustedH)
    }

    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(78.adjustedH)
      $0.leading.trailing.equalToSuperview().inset(38.adjustedH)
    }

    codeInputDescLabel.snp.makeConstraints {
      $0.leading.equalTo(titleLabel)
      $0.top.equalTo(titleLabel.snp.bottom).offset(18.adjustedH)
      $0.height.lessThanOrEqualTo(40)
    }

    timerLabel.snp.makeConstraints {
      $0.leading.equalTo(codeInputDescLabel.snp.trailing)
      $0.trailing.equalTo(titleLabel).priority(.high)
      $0.bottom.equalTo(codeInputDescLabel)
    }

    codeInputTextField.snp.makeConstraints {
      $0.leading.trailing.equalTo(titleLabel)
      $0.top.equalTo(codeInputDescLabel.snp.bottom).offset(33.adjustedH)
      $0.height.greaterThanOrEqualTo(40)
    }

    codeInputErrDesc.snp.makeConstraints {
      $0.top.equalTo(codeInputTextField.snp.bottom).offset(10)
      $0.leading.trailing.equalTo(titleLabel)
    }

    resendButton.snp.makeConstraints {
      $0.top.equalTo(codeInputTextField.snp.bottom).offset(24.adjustedH)
      $0.leading.equalTo(titleLabel)
      $0.height.lessThanOrEqualTo(50)
    }
  }

  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    blurView.alpha = 0
    successPopup.isHidden = true
    codeInputTextField.text = ""
  }

  public override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    codeInputTextField.becomeFirstResponder()
  }

  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    blurView.frame = self.view.bounds
  }

  public override func bindViewModel() {
    let publishSubject = PublishSubject<String>()
    let animationFinish = PublishRelay<Void>()
    
    codeInputTextField.didFinish = {
      publishSubject.onNext($0)
    }

    let input = ViewModel.Input(
      viewWillAppear: rx.viewWillAppear.asSignal().map { _ in },
      codeInput: publishSubject.asDriverOnErrorJustEmpty(),
      finishAnimationTrigger: animationFinish.asSignal(),
      resendBtnTap: resendButton.rx.tap.asSignal()
        .do(onNext: { [weak self] in
          self?.codeInputTextField.text = ""
        })
    )

    let output = viewModel.transform(input: input)

    output.description
      .drive(codeInputDescLabel.rx.text)
      .disposed(by: disposeBag)

    output.error
      .drive(with: self, onNext: { owner, error in
        print(error.localizedDescription)
      })
      .disposed(by: disposeBag)

    output.certificateSuccess
      .drive(with: self) { owner, _ in
        DispatchQueue.main.async {
          owner.codeInputTextField.resignFirstResponder()
        }
      }.disposed(by: disposeBag)

    output.certificateSuccess
      .drive(with: self) { owner, _ in
        owner.blurView.alpha = 1
        owner.successPopup.isHidden = false
        owner.successPopup.animationPlay {
          animationFinish.accept(())
        }
      }
      .disposed(by: disposeBag)
    
    output.certificateFailuer
      .drive(with: self) { owner, _ in
        owner.codeInputErrDesc.isHidden = false
        owner.codeInputTextField.onError()
      }.disposed(by: disposeBag)

    output.timestamp
      .drive(timerLabel.rx.text)
      .disposed(by: disposeBag)
  }
}
