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

  private let viewModel: NicknameInputViewModel

  init(viewModel: NicknameInputViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func makeUI() {
    view.addSubview(mainView)
    mainView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    keyBoardSetting()
  }

  override func bindViewModel() {
    let viewWillAppear =  rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
      .do(onNext: { [weak self] _ in
        self?.mainView.nicknameInputView.becomeFirstResponder()
      })
      .map { _ in }
      .asDriver(onErrorDriveWith: .empty())

    let input = NicknameInputViewModel.Input(
      viewWillAppear: viewWillAppear,
      nickname: mainView.nicknameInputField.textField.rx.text.orEmpty.asDriver(),
      clearBtn: mainView.nicknameInputField.clearBtn.rx.tap.asDriver(),
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
//      .do(onNext: { [weak self] status in
//        self?.mainView.nextBtn.updateColors(status: isEnabled)
//      })
//      .drive(mainView.nextBtn.rx.isEnabled)
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
//
//    RxKeyboard.instance.visibleHeight
//      .skip(1)
//      .drive(with: self, onNext: { owner, keyboardHeight in
//        if keyboardHeight == 0 {
//          owner.mainView.snp.updateConstraints {
//            $0.bottom.equalToSuperview().inset(14)
//          }
//        } else {
//          owner.mainView.nextBtn.snp.updateConstraints {
//            $0.bottom.equalToSuperview().inset(keyboardHeight - owner.view.safeAreaInsets.bottom + 14)
//          }
//        }
//      })
//      .disposed(by: disposeBag)
  }
}
