//
//  PhoneCertificationViewController.swift
//  DSKit
//
//  Created by Hoo's MacBookPro on 2023/08/03.
//

import UIKit

import DSKit

final class NicknameInputViewController: TFBaseViewController {

  fileprivate let mainView = NicknameView()

  override func loadView() {
    self.view = mainView
  }
  
  private let viewModel: NicknameInputViewModel

  init(viewModel: NicknameInputViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    keyBoardSetting()
  }

  override func bindViewModel() {
    let viewWillAppear =  rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
      .do(onNext: { [weak self] _ in
        self?.mainView.nicknameTextField.becomeFirstResponder()
      })
      .map { _ in }
      .asDriver(onErrorDriveWith: .empty())

    let input = NicknameInputViewModel.Input(
      viewWillAppear: viewWillAppear,
      nickname: mainView.nicknameTextField.rx.text.orEmpty.asDriver(),
      clearBtn: mainView.clearBtn.rx.tap.asDriver(),
      nextBtn: mainView.nextBtn.rx.tap.asDriver()
    )

    let output = viewModel.transform(input: input)
//
//    output.phoneNum
//      .drive(phoneNumTextField.rx.text)
//      .disposed(by: disposeBag)
//
//    output.phoneNum
//      .map { $0 + "으로\n전송된 코드를 입력해주세요."}
//      .drive(codeInputDescLabel.rx.text)
//      .disposed(by: disposeBag)
//
//    output.validate
//      .filter { $0 == true }
//      .map { _ in DSKitAsset.Color.primary500.color }
//      .drive(verifyBtn.rx.backgroundColor)
//      .disposed(by: disposeBag)
//
//    output.validate
//      .filter { $0 == false }
//      .map { _ in DSKitAsset.Color.disabled.color }
//      .drive(verifyBtn.rx.backgroundColor)
//      .disposed(by: disposeBag)
//
//    output.validate
//      .map { $0 == true }
//      .drive(verifyBtn.rx.isEnabled)
//      .disposed(by: disposeBag)
//
//    output.error
//      .asSignal()
//      .emit {
//        print($0)
//      }.disposed(by: disposeBag)
//
//    output.clearButtonTapped
//      .drive(phoneNumTextField.rx.text)
//      .disposed(by: disposeBag)
//
//
//    output.viewStatus
//      .map { $0 != .authCode }
//      .drive(codeInputView.rx.isHidden)
//      .disposed(by: disposeBag)
//
//    output.viewStatus
//      .map { $0 != .phoneNumber }
//      .drive(onNext: { [weak self] in
//        guard let self else { return }
//        if $0 {
//          self.codeInputTextField.becomeFirstResponder()
//        }
//      })
//      .disposed(by: disposeBag)

//
//    output.navigatorDisposble
//      .drive()
//      .disposed(by: disposeBag)
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
      .drive(with: self, onNext: { owner, keyboardHeight in
        if keyboardHeight == 0 {
          owner.mainView.snp.updateConstraints {
            $0.bottom.equalToSuperview().inset(14)
          }
        } else {
          owner.mainView.nextBtn.snp.updateConstraints {
            $0.bottom.equalToSuperview().inset(keyboardHeight - owner.view.safeAreaInsets.bottom + 14)
          }
        }
      })
      .disposed(by: disposeBag)
  }
}
