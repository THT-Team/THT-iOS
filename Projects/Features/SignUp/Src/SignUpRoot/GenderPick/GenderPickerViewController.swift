//
//  GenderPickerViewController.swift
//  SignUpInterface
//
//  Created by Kanghos on 2024/04/16.
//

import UIKit

import DSKit

import SignUpInterface
import RxSwift
import RxCocoa
import RxGesture

final class GenderPickerViewController: BaseSignUpVC<GenderPickerViewModel>, StageProgressable {
  private let mainView = GenderPickerView()

  override func loadView() {
    self.view = mainView
  }

  var stage: Float = 2

  override func bindViewModel() {
    let birthdayTap = self.mainView.birthdayLabel
      .rx
      .tapGesture()
      .when(.recognized)
      .map { _ in }
      .asDriverOnErrorJustEmpty()

    let genderTap = self.mainView.genderPickerView
      .rx.selectedOption
      .asDriver()
      .compactMap { $0 }
      .map { option -> Gender in
        switch option {
        case .left:
          return .female
        case .right:
          return .male
        }
      }

    let input = GenderPickerViewModel.Input(
      genderTap: genderTap,
      birthdayTap: birthdayTap,
      nextBtnTap: self.mainView.nextBtn.rx.tap.asDriver()
    )
    
    let output = viewModel.transform(input: input)

    output.initialGender
      .compactMap { $0 }
      .drive(self.mainView.rx.selectedGender)
      .disposed(by: disposeBag)

    output.birthday
      .drive(with: self) { owner, selectedDate in
        owner.mainView.birthdayLabel.text = selectedDate
        owner.mainView.birthdayLabel.textColor = DSKitAsset.Color.primary500.color
      }
      .disposed(by: disposeBag)

    output.isNextBtnEnabled
      .drive(self.mainView.nextBtn.rx.buttonStatus)
      .disposed(by: disposeBag)
  }
}

