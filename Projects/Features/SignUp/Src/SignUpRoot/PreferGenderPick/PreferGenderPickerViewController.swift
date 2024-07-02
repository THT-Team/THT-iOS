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

final class PreferGenderPickerViewController: BaseSignUpVC<PreferGenderPickerViewModel>, StageProgressable {
  private let mainView = PreferGenderPickerView()
  var stage: Float = 3

  override func loadView() {
    self.view = mainView
  }

  override func bindViewModel() {
    let genderTap = self.mainView.genderPickerView
      .rx.selectedOption
      .asDriver()
      .compactMap { $0 }
      .compactMap { GenderMapper.toGender($0) }

    let input = ViewModel.Input(
      viewWillAppear: rx.viewWillAppear.mapToVoid().asDriverOnErrorJustEmpty(),
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

