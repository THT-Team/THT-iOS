//
//  IntroduceInputViewController.swift
//  SignUpInterface
//
//  Created by Kanghos on 2024/04/24.
//

import UIKit

import DSKit

final class IntroduceInputViewController: TFBaseViewController {

  private let viewModel: IntroduceInputViewModel
  private lazy var mainView = IntroduceInputView()

  init(viewModel: IntroduceInputViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func loadView() {
    self.view = mainView
  }


  override func bindViewModel() {
    super.bindViewModel()

    let input = IntroduceInputViewModel.Input(
      nextBtn: self.mainView.nextBtn.rx.tap.asDriver(),
      introduceText: self.mainView.introduceInputField.rx.text.orEmpty.asDriver()
    )

    let output = viewModel.transform(input: input)

    output.isEnableNextBtn
      .drive(self.mainView.nextBtn.rx.isEnabled)
      .disposed(by: disposeBag)
  }
}

