//
//  PhoneCertificationViewController.swift
//  DSKit
//
//  Created by Hoo's MacBookPro on 2023/08/03.
//

import UIKit

import DSKit

final class  NicknameInputViewController: BaseSignUpVC<NicknameInputViewModel>, StageProgressable {
  fileprivate let mainView = NicknameView()
  var stage: Float = 1

  override func loadView() {
    self.view = mainView
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    mainView.nicknameInputField.becomeFirstResponder()
  }

  override func bindViewModel() {
    let input = NicknameInputViewModel.Input(
      nickname: mainView.nicknameInputField.rx.text.asDriver(),
      nextBtn: mainView.nextBtn.rx.tap.asDriver()
    )

    let output = viewModel.transform(input: input)
    
    output.errorField
      .debug("errorField")
      .drive(with: self, onNext: { owner, message in
        owner.mainView.nicknameInputField.send(action: TFCounterTextField.Action.error(inputError: InputError.validate(text: message)))
      })
      .disposed(by: disposeBag)
    
    output.validate
      .drive(mainView.nextBtn.rx.buttonStatus)
      .disposed(by: disposeBag)

    output.initialValue
      .drive(mainView.nicknameInputField.rx.text)
      .disposed(by: disposeBag)
  }
}
