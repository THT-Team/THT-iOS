//
//  LocationInputViewController.swift
//  SignUp
//
//  Created by Kanghos on 2024/04/27.
//

import UIKit

import DSKit

final class LocationInputViewController: BaseSignUpVC<LocationInputViewModel>, StageProgressable {
  var stage: Float = 11

  private let mainView = LocationInputView()

  override func loadView() {
    self.view = mainView
  }

  override func bindViewModel() {

    let input = ViewModel.Input(
      locationBtnTap: mainView.locationField.rx.tap.asSignal(),
      nextBtn: mainView.nextBtn.rx.tap.asSignal()
    )

    let output = viewModel.transform(input: input)

    output.isNextBtnEnabled
      .drive(self.mainView.nextBtn.rx.buttonStatus)
      .disposed(by: disposeBag)
    
    output.currentLocation
      .drive(self.mainView.locationField.rx.location)
      .disposed(by: disposeBag)
  }
}

