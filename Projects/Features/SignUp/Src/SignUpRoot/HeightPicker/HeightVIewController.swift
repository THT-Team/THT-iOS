//
//  HeightVIewController.swift
//  SignUp
//
//  Created by Kanghos on 2024/04/21.
//

import UIKit

import DSKit

import RxSwift
import RxCocoa
import RxGesture

final class HeightPickerViewController: TFBaseViewController {
  private let mainView = HeightPickerView()
  private let viewModel: HeightPickerViewModel

  init(viewModel: HeightPickerViewModel) {
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
    let pickerLabelTap = self.mainView.heightLabel
      .rx
      .tapGesture()
      .when(.recognized)
      .map { _ in }
      .asDriverOnErrorJustEmpty()

    let input = HeightPickerViewModel.Input(
      pickerLabelTap: pickerLabelTap,
      nextBtnTap: self.mainView.nextBtn.rx.tap.asDriver()
    )

    let output = viewModel.transform(input: input)

    output.height
      .drive(with: self) { owner, value in
        owner.mainView.heightLabel.text = value
      }
      .disposed(by: disposeBag)

    output.isNextBtnEnabled
      .drive(with: self) { owner, status in
        owner.mainView.nextBtn.updateColors(status: status)
      }
      .disposed(by: disposeBag)
  }
}

