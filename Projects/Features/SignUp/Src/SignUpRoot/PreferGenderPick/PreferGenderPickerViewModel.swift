//
//  PreferGenderPickerViewModel.swift
//  SignUp
//
//  Created by Kanghos on 2024/04/18.
//

import Foundation

import Core
import SignUpInterface

import RxSwift
import RxCocoa

final class PreferGenderPickerViewModel: ViewModelType {
  weak var delegate: SignUpCoordinatingActionDelegate?

  struct Input {
    var genderTap: Driver<Gender>
    var nextBtnTap: Driver<Void>
  }

  struct Output {
    var isNextBtnEnabled: Driver<Bool>
  }

  private var disposeBag = DisposeBag()

  func transform(input: Input) -> Output {
    let selectedGender = input.genderTap

    let nextBtnisEnabled = selectedGender.map { _ in true }

    input.nextBtnTap
      .drive(with: self) { owner, _ in
        owner.delegate?.invoke(.nextAtGender)
      }.disposed(by: disposeBag)

    return Output(
      isNextBtnEnabled: nextBtnisEnabled
    )
  }
}
