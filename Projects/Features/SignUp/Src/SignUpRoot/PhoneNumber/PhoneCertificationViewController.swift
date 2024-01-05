//
//  PhoneCertificationViewController.swift
//  DSKit
//
//  Created by Hoo's MacBookPro on 2023/08/03.
//

import UIKit

import Core

import SnapKit
import Then
import RxCocoa
import RxSwift
import RxKeyboard
import RxGesture

final class PhoneCertificationViewController: TFBaseViewController {

  private lazy var phoneNumberInputeView = UIView().then {
    $0.backgroundColor = DSKitAsset.Color.neutral700.color
  }

  private lazy var titleLabel: UILabel = UILabel().then {
    $0.text = "핸드폰 번호 인증"
    $0.font = .thtH1B
    $0.textColor = DSKitAsset.Color.neutral50.color
  }

  private lazy var phoneNumTextField: UITextField = UITextField().then {
    $0.placeholder = "01012345678"
    $0.textColor = DSKitAsset.Color.primary500.color
    $0.font = .thtH2B
    $0.keyboardType = .numberPad
  }

  private lazy var clearBtn: UIButton = UIButton().then {
    $0.setImage(DSKitAsset.Image.closeCircle.image, for: .normal)
    $0.setTitle(nil, for: .normal)
    $0.backgroundColor = .clear
  }

  private lazy var divider: UIView = UIView().then {
    $0.backgroundColor = DSKitAsset.Color.neutral300.color
  }

  private lazy var infoImageView: UIImageView = UIImageView().then {
    $0.image = DSKitAsset.Image.explain.image.withRenderingMode(.alwaysTemplate)
    $0.tintColor = DSKitAsset.Color.neutral400.color
  }

  private lazy var descLabel: UILabel = UILabel().then {
    $0.text = "핸드폰 번호 입력 시, 인증 코드를 문자 메세지로 발송합니다.\n핸드폰 번호는 다른 사람들에게 공유되거나 프로필에 표시하지 않습니다."
    $0.font = .thtCaption1M
    $0.textColor = DSKitAsset.Color.neutral400.color
    $0.textAlignment = .left
    $0.numberOfLines = 4
  }

  private lazy var verifyBtn: UIButton = UIButton().then {
    $0.setTitle("인증하기", for: .normal)
    $0.setTitleColor(DSKitAsset.Color.neutral600.color, for: .normal)
    $0.titleLabel?.font = .thtH5B
    $0.backgroundColor = DSKitAsset.Color.primary500.color
    $0.layer.cornerRadius = 16
  }

  private lazy var codeInputView = UIView().then {
    $0.backgroundColor = DSKitAsset.Color.neutral700.color
  }

  private lazy var codeInputTitle = UILabel().then {
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
    $0.textColor = DSKitAsset.Color.neutral50.color
  }

  private lazy var codeInputTextField = UITextField().then {
    $0.font = .thtH1B
    $0.textColor = DSKitAsset.Color.primary500.color
    $0.keyboardType = .numberPad
  }

  private lazy var codeInputUnderLine = UIView().then {
    $0.backgroundColor = DSKitAsset.Color.neutral300.color
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

  private let viewModel: PhoneCertificationViewModel

  init(viewModel: PhoneCertificationViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func makeUI() {
    [phoneNumberInputeView, codeInputView, successPopup].forEach {
      view.addSubview($0)
    }

    [titleLabel, phoneNumTextField, clearBtn, divider, infoImageView, descLabel, verifyBtn].forEach {
      phoneNumberInputeView.addSubview($0)
    }

    [codeInputTitle, codeInputDescLabel,
     timerLabel, codeInputTextField,
     codeInputUnderLine, resendButton, codeInputErrDesc]
      .forEach { codeInputView.addSubview($0) }

    phoneNumberInputeView.snp.makeConstraints {
      $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
      $0.leading.trailing.equalToSuperview()
    }

    codeInputView.snp.makeConstraints {
      $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
      $0.leading.trailing.equalToSuperview()
    }

    successPopup.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().inset(view.frame.height * 0.09)
      $0.leading.equalToSuperview().inset(38)
    }

    phoneNumTextField.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(32)
      $0.leading.equalToSuperview().inset(38)
      $0.trailing.equalTo(clearBtn.snp.trailing)
    }

    clearBtn.snp.makeConstraints {
      $0.centerY.equalTo(phoneNumTextField.snp.centerY)
      $0.width.height.equalTo(24)
      $0.trailing.equalToSuperview().inset(38)
    }

    divider.snp.makeConstraints {
      $0.leading.equalTo(phoneNumTextField.snp.leading)
      $0.trailing.equalTo(clearBtn.snp.trailing)
      $0.height.equalTo(2)
      $0.top.equalTo(phoneNumTextField.snp.bottom).offset(2)
    }

    infoImageView.snp.makeConstraints {
      $0.leading.equalTo(phoneNumTextField.snp.leading)
      $0.width.height.equalTo(16)
      $0.top.equalTo(divider.snp.bottom).offset(16)
    }

    descLabel.snp.makeConstraints {
      $0.leading.equalTo(infoImageView.snp.trailing).offset(6)
      $0.top.equalTo(divider.snp.bottom).offset(16)
      $0.trailing.equalToSuperview().inset(38)
    }

    verifyBtn.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(38)
      $0.bottom.equalToSuperview().offset(14)
      $0.height.equalTo(54)
    }

    codeInputTitle.snp.makeConstraints {
      $0.top.equalToSuperview().inset(view.frame.height * 0.09)
      $0.leading.equalToSuperview().inset(38)
    }

    codeInputDescLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().inset(38)
      $0.top.equalTo(codeInputTitle.snp.bottom).offset(18)
    }

    timerLabel.snp.makeConstraints {
      $0.trailing.equalToSuperview().inset(38)
      $0.bottom.equalTo(codeInputDescLabel.snp.bottom)
    }

    codeInputTextField.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(38)
      $0.top.equalTo(codeInputDescLabel.snp.bottom).offset(33)
      $0.height.equalTo(40)
    }

    codeInputUnderLine.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(38)
      $0.top.equalTo(codeInputTextField.snp.bottom)
      $0.height.equalTo(2)
    }

    resendButton.snp.makeConstraints {
      $0.top.equalTo(codeInputUnderLine.snp.bottom).offset(24)
      $0.leading.equalToSuperview().inset(38)
    }

    codeInputErrDesc.snp.makeConstraints {
      $0.top.equalTo(codeInputUnderLine.snp.bottom).offset(6)
      $0.leading.equalToSuperview().inset(38)
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    keyBoardSetting()
    setupAccessibilityIdentifier()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    phoneNumTextField.becomeFirstResponder()
  }

  override func bindViewModel() {
    let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
      .map { _ in () }
      .asDriver(onErrorJustReturn: ())

    let finishAnimationTrigger = PublishSubject<Void>()

    let input = PhoneCertificationViewModel.Input(
      viewWillAppear: viewWillAppear,
      phoneNum: phoneNumTextField.rx.text.orEmpty.asDriver(),
      clearBtn: clearBtn.rx.tap.asDriver(),
      verifyBtn: verifyBtn.rx.tap.withLatestFrom(phoneNumTextField.rx.text.orEmpty)
        .asDriver(onErrorJustReturn: ""),
      codeInput: codeInputTextField.rx.text.orEmpty.asDriver(),
      finishAnimationTrigger: finishAnimationTrigger.asDriver(onErrorJustReturn: ())
    )

    let output = viewModel.transform(input: input)

    output.phoneNum
      .drive(phoneNumTextField.rx.text)
      .disposed(by: disposeBag)

    output.phoneNum
      .map { $0 + "으로\n전송된 코드를 입력해주세요."}
      .drive(codeInputDescLabel.rx.text)
      .disposed(by: disposeBag)

    output.validate
      .filter { $0 == true }
      .map { _ in DSKitAsset.Color.primary500.color }
      .drive(verifyBtn.rx.backgroundColor)
      .disposed(by: disposeBag)

    output.validate
      .filter { $0 == false }
      .map { _ in DSKitAsset.Color.disabled.color }
      .drive(verifyBtn.rx.backgroundColor)
      .disposed(by: disposeBag)

    output.validate
      .map { $0 == true }
      .drive(verifyBtn.rx.isEnabled)
      .disposed(by: disposeBag)

    output.error
      .asSignal()
      .emit {
        print($0)
      }.disposed(by: disposeBag)

    output.clearButtonTapped
      .drive(phoneNumTextField.rx.text)
      .disposed(by: disposeBag)

    output.viewStatus
      .map { $0 != .phoneNumber }
      .drive(phoneNumberInputeView.rx.isHidden)
      .disposed(by: disposeBag)

    output.viewStatus
      .map { $0 != .authCode }
      .drive(codeInputView.rx.isHidden)
      .disposed(by: disposeBag)

    output.viewStatus
      .map { $0 != .phoneNumber }
      .drive(onNext: { [weak self] in
        guard let self else { return }
        if $0 {
          self.codeInputTextField.becomeFirstResponder()
        }
      })
      .disposed(by: disposeBag)

    output.certificateSuccess
      .map { !$0 }
      .drive(onNext: { [weak self] isSuccess in
        guard let self else { return }
        self.successPopup.isHidden = isSuccess
        self.successPopup.animationPlay {
          finishAnimationTrigger.onNext(Void())
        }
      })
      .disposed(by: disposeBag)

    output.certificateSuccess
      .asObservable()
      .observe(on: MainScheduler.asyncInstance)
      .subscribe(onNext: { [weak self] _ in
        guard let self else { return }
        view.endEditing(true)
      })
      .disposed(by: disposeBag)

    output.certificateFailuer
      .map { _ in DSKitAsset.Color.error.color }
      .drive(codeInputUnderLine.rx.backgroundColor)
      .disposed(by: disposeBag)

    output.certificateFailuer
      .drive(codeInputErrDesc.rx.isHidden)
      .disposed(by: disposeBag)

    output.timeStampLabel
      .drive(timerLabel.rx.text)
      .disposed(by: disposeBag)

    output.timeLabelTextColor
      .map { return $0.color }
      .drive(timerLabel.rx.textColor)
      .disposed(by: disposeBag)

    output.navigatorDisposble
      .drive()
      .disposed(by: disposeBag)
  }

  func keyBoardSetting() {
    view.rx.tapGesture()
      .when(.recognized)
      .withUnretained(self)
      .subscribe { vc, _ in
        vc.view.endEditing(true)
      }
      .disposed(by: disposeBag)

    RxKeyboard.instance.visibleHeight
      .skip(1)
      .drive(onNext: { [weak self] keyboardHeight in
        guard let self else { return }
        if keyboardHeight == 0 {
          self.verifyBtn.snp.updateConstraints {
            $0.bottom.equalToSuperview().inset(14)
          }
        } else {
          self.verifyBtn.snp.updateConstraints {
            $0.bottom.equalToSuperview().inset(keyboardHeight - self.view.safeAreaInsets.bottom + 14)
          }
        }
      })
      .disposed(by: disposeBag)
  }
}

extension PhoneCertificationViewController {

  private func setupAccessibilityIdentifier() {
    phoneNumTextField.accessibilityIdentifier = AccessibilityIdentifier.phoneNumberTextField
    verifyBtn.accessibilityIdentifier = AccessibilityIdentifier.verifyBtn
  }
}
