//
//  EmailInputViewController.swift
//  Falling
//
//  Created by Hoo's MacBookPro on 2023/08/06.
//

import UIKit

import Core
import DSKit

import RxSwift
import RxCocoa
import RxKeyboard
import RxGesture
import Then
import SnapKit

class EmailInputViewController: TFBaseViewController {

  private lazy var titleLable: UILabel = UILabel().then {
    $0.text = "이메일 입력"
    $0.font = .thtH1B
    $0.textColor = DSKitAsset.Color.neutral50.color
  }

  private lazy var emailTextField: UITextField = UITextField().then {
    $0.placeholder = "welcome@falling.com"
    $0.textColor = DSKitAsset.Color.primary500.color
    $0.font = .thtH2B
  }

  private lazy var clearBtn: UIButton = UIButton().then {
    $0.setImage(DSKitAsset.Image.Icons.closeCircle.image, for: .normal)
    $0.setTitle(nil, for: .normal)
    $0.backgroundColor = .clear
  }

  private lazy var divider: UIView = UIView().then {
    $0.backgroundColor = DSKitAsset.Color.neutral300.color
  }

  private lazy var descView = UIView().then {
    $0.backgroundColor = .cyan
  }

  private lazy var descImageView: UIImageView = UIImageView().then {
    $0.image = DSKitAsset.Image.Icons.explain.image.withRenderingMode(.alwaysTemplate)
    $0.tintColor = DSKitAsset.Color.neutral400.color
  }

  private lazy var warningLabel: UILabel = UILabel().then {
    $0.text = "올바른 이메일 주소를 입력해주세요."
    $0.font = .thtCaption1R
    $0.textColor = DSKitAsset.Color.error.color
    $0.isHidden = true
  }

  private lazy var autoDomainListView: UIStackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 8
    $0.alignment = .leading
  }

  private lazy var naverDomainBtn = EmailDomainBtn(emailDomain: .naver)
  private lazy var gmailDomainBtn = EmailDomainBtn(emailDomain: .gmail)
  private lazy var kakaoDomainBtn = EmailDomainBtn(emailDomain: .kakao)

  private lazy var descLabel: UILabel = UILabel().then {
    $0.font = .thtCaption1M
    $0.textColor = DSKitAsset.Color.neutral400.color
    $0.text = "이메일 계정 인증으로 로그인 문제가 생길 시 이메일로\n계정 복구를 진행합니다. 따로 프로필에 표시 되지 않습니다."
    $0.numberOfLines = 2
  }

  private lazy var nextButton = CTAButton(btnTitle: "다음",
                                          initialStatus: false)

  init(viewModel: EmailInputViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  private let viewModel: EmailInputViewModel

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    emailTextField.becomeFirstResponder()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    keyboardSetting()
  }

  override func makeUI() {
    [
      titleLable,
      emailTextField,
      clearBtn,
      divider,
      warningLabel,
      autoDomainListView,
      descView,
      nextButton
    ].forEach { view.addSubview($0) }

    [descImageView, descLabel]
      .forEach { descView.addSubview($0) }

    [naverDomainBtn, gmailDomainBtn, kakaoDomainBtn]
      .forEach { autoDomainListView.addArrangedSubview($0) }

    titleLable.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(38)
      $0.top.equalTo(view.safeAreaLayoutGuide).inset(76)
    }

    emailTextField.snp.makeConstraints {
      $0.leading.equalTo(view.safeAreaLayoutGuide).inset(38)
      $0.trailing.equalTo(clearBtn.snp.leading).offset(2)
      $0.top.equalTo(titleLable.snp.bottom).offset(32)
    }

    clearBtn.snp.makeConstraints {
      $0.width.height.equalTo(24)
      $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(38)
      $0.centerY.equalTo(emailTextField)
    }

    divider.snp.makeConstraints {
      $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(38)
      $0.top.equalTo(emailTextField.snp.bottom).offset(2)
      $0.height.equalTo(2)
    }

    warningLabel.snp.makeConstraints {
      $0.leading.equalTo(divider.snp.leading)
      $0.top.equalTo(divider.snp.bottom).offset(6)
      $0.height.equalTo(15)
    }

    autoDomainListView.snp.makeConstraints {
      $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(38)
      $0.top.equalTo(divider.snp.bottom).offset(25)
    }

    descView.snp.makeConstraints {
      $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(38)
      $0.top.equalTo(divider.snp.bottom).offset(16)
      $0.height.equalTo(descLabel.snp.height)
    }

    descImageView.snp.makeConstraints {
      $0.leading.top.equalToSuperview()
      $0.width.height.equalTo(16)
    }

    descLabel.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.equalTo(descImageView.snp.trailing).offset(6)
    }

    nextButton.snp.makeConstraints {
      $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(38)
      $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(14)
      $0.height.equalTo(54)
    }
  }

  override func bindViewModel() {
    let emailTFStrDriver = emailTextField.rx.text.orEmpty.asDriver()

    emailTFStrDriver
      .drive(naverDomainBtn.rx.setTitle, gmailDomainBtn.rx.setTitle, kakaoDomainBtn.rx.setTitle)
      .disposed(by: disposeBag)

    let input = EmailInputViewModel.Input(
      emailText: emailTFStrDriver,
      clearBtnTapped: clearBtn.rx.tap.asDriver(),
      nextBtnTap: nextButton.rx.tap.asDriver(),
      naverBtnTapped: naverDomainBtn.rx.tap.asDriver(),
      kakaoBtnTapped: kakaoDomainBtn.rx.tap.asDriver(),
      gmailBtnTapped: gmailDomainBtn.rx.tap.asDriver()
    )

    let output = viewModel.transform(input: input)

    output.buttonState
      .drive(nextButton.rx.buttonStatus, nextButton.rx.isEnabled)
      .disposed(by: disposeBag)

    output.buttonTappedResult
      .drive()
      .disposed(by: disposeBag)

    output.emailTextStatus
      .drive(with: self, onNext: { vc, state in
        switch state {
        case .empty, .valid:
          vc.warningLabel.isHidden = true
          vc.autoDomainListView.isHidden = true
          vc.descView.snp.remakeConstraints {
            $0.top.equalTo(vc.divider.snp.bottom).offset(16)
            $0.leading.equalTo(vc.divider.snp.leading)
            $0.trailing.equalTo(vc.divider.snp.trailing)
          }
        case .invalid:
          vc.warningLabel.isHidden = false
          vc.autoDomainListView.isHidden = false

          vc.warningLabel.snp.remakeConstraints {
            $0.top.equalTo(vc.divider.snp.bottom).offset(6)
            $0.leading.equalTo(vc.divider.snp.leading)
            $0.height.equalTo(15)
          }

          vc.autoDomainListView.snp.remakeConstraints {
            $0.top.equalTo(vc.warningLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalTo(vc.divider)
          }

          vc.descView.snp.remakeConstraints {
            $0.top.equalTo(vc.autoDomainListView.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(vc.divider)
          }
        }
      })
      .disposed(by: disposeBag)

    output.emailText
      .drive(emailTextField.rx.text)
      .disposed(by: disposeBag)
  }

  func keyboardSetting() {
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
          self.nextButton.snp.updateConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(14)
          }
        } else {
          self.nextButton.snp.updateConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(keyboardHeight - self.view.safeAreaInsets.bottom + 14)
          }
        }

        if keyboardHeight == 0 {
          self.titleLable.snp.updateConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide).inset(76)
          }
        } else {
          self.titleLable.snp.updateConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide).inset(20)
          }
        }
      })
      .disposed(by: disposeBag)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
