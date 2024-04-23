//
//  GenderPickerViewController.swift
//  SignUpInterface
//
//  Created by Kanghos on 2024/04/16.
//

import UIKit

import DSKit

import RxSwift
import RxCocoa
import RxGesture

final class GenderPickerViewController: TFBaseViewController {
  private let mainView = GenderPickerView()
  private let viewModel: GenderPickerViewModel

  init(viewModel: GenderPickerViewModel) {
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

    output.birthday
      .drive(with: self) { owner, selectedDate in
        owner.mainView.birthdayLabel.text = selectedDate
      }
      .disposed(by: disposeBag)

    output.isNextBtnEnabled
      .drive(with: self) { owner, status in
        owner.mainView.nextBtn.updateColors(status: status)
      }
      .disposed(by: disposeBag)
  }
}

