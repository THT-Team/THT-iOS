//
//  IntroduceInputViewController.swift
//  SignUpInterface
//
//  Created by Kanghos on 2024/04/24.
//

import UIKit

import DSKit

final class IntroduceInputViewController: BaseSignUpVC<IntroduceInputViewModel>, StageProgressable {
  var stage: Float = 10

  private lazy var mainView = IntroduceInputView()

  override func loadView() {
    self.view = mainView
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    mainView.introduceInputField.becomeFirstResponder()
  }

  override func bindViewModel() {
    super.bindViewModel()

    let input = ViewModel.Input(
      nextBtn: self.mainView.nextBtn.rx.tap.asDriver(),
      introduceText: self.mainView.introduceInputField.rx.text.asDriver()
    )

    let output = viewModel.transform(input: input)

    output.isEnableNextBtn
      .drive(self.mainView.nextBtn.rx.buttonStatus)
      .disposed(by: disposeBag)

    output.initialValue
      .debug("introduce")
      .drive(self.mainView.introduceInputField.rx.text)
      .disposed(by: disposeBag)
  }
}

