//
//  LocationInputViewController.swift
//  SignUp
//
//  Created by Kanghos on 2024/04/27.
//

import UIKit

import DSKit

final class LocationInputViewController: TFBaseViewController {
  typealias ViewModel = LocationInputViewModel
  private let mainView = LocationInputView()
  private let viewModel: LocationInputViewModel

  init(viewModel: ViewModel) {
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
    let input = ViewModel.Input(
      locationBtnTap: self.mainView.locationField.rx.tap.asDriver(),
      nextBtn: self.mainView.nextBtn.rx.tap.asDriver()
    )

    let output = viewModel.transform(input: input)

    output.isNextBtnEnabled
      .drive(self.mainView.nextBtn.rx.buttonStatus)
      .disposed(by: disposeBag)
  }
}

