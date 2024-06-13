//
//  AlcoholTobaccoInputViewControlle.swift
//  SignUp
//
//  Created by Kanghos on 2024/04/21.
//

import UIKit

import DSKit

import RxSwift
import RxCocoa

final class AlcoholTobaccoPickerViewController: TFBaseViewController {
  private let mainView = AlcoholTobaccoPickerView()
  private let viewModel: AlcoholTobaccoPickerViewModel

  init(viewModel: AlcoholTobaccoPickerViewModel) {
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
    let tobaccoTap = self.mainView.tobaccoPickerView
      .rx.selectedOption
      .asDriver()
      .compactMap { $0 }
      .map { FrequencyMapper.toFrequency($0) }

    let alcoholTap = self.mainView.alcoholPickerView
      .rx.selectedOption
      .asDriver()
      .compactMap { $0 }
      .map { FrequencyMapper.toFrequency($0) }

    let input = AlcoholTobaccoPickerViewModel.Input(
      tobaccoTap: tobaccoTap,
      alcoholTap: alcoholTap,
      nextBtnTap: self.mainView.nextBtn.rx.tap.asDriver()
    )

    let output = viewModel.transform(input: input)

    output.isNextBtnEnabled
      .drive(with: self) { owner, status in
        owner.mainView.nextBtn.updateColors(status: status)
      }
      .disposed(by: disposeBag)

    output.initialFrequecy
      .debug("initial")
      .drive(mainView.rx.selectedFrequecy)
      .disposed(by: disposeBag)
  }
}

