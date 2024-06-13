//
//  PreferGenderPickerViewController.swift
//  SignUp
//
//  Created by Kanghos on 2024/04/18.
//

import UIKit

import DSKit
import SignUpInterface

import RxSwift
import RxCocoa

final class PreferGenderPickerViewController: TFBaseViewController {
  private let mainView = PreferGenderPickerView()
  private let viewModel: PreferGenderPickerViewModel

  init(viewModel: PreferGenderPickerViewModel) {
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
    let genderTap = self.mainView.genderPickerView
      .rx.selectedOption
      .asDriver()
      .compactMap { $0 }
      .compactMap { GenderMapper.toGender($0) }

    let input = PreferGenderPickerViewModel.Input(
      genderTap: genderTap,
      nextBtnTap: self.mainView.nextBtn.rx.tap.asDriver()
    )

    let output = viewModel.transform(input: input)

    output.isNextBtnEnabled
      .drive(with: self) { owner, status in
        owner.mainView.nextBtn.updateColors(status: status)
      }
      .disposed(by: disposeBag)

    output.initialGender
      .debug("initialGender")
      .drive(mainView.rx.selectedGender)
      .disposed(by: disposeBag)
  }
}

