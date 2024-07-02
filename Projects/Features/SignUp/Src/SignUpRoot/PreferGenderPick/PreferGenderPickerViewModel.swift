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

final class PreferGenderPickerViewModel: BasePenddingViewModel, ViewModelType {

  struct Input {
    let viewWillAppear: Driver<Void>
    var genderTap: Driver<Gender>
    var nextBtnTap: Driver<Void>
  }

  struct Output {
    var isNextBtnEnabled: Driver<Bool>
    var initialGender: Driver<Gender>
  }

  func transform(input: Input) -> Output {

    let initialGender = Driver.just(self.pendingUser.preferGender).compactMap { $0 }
    let selectedGender = input.genderTap

    let nextBtnisEnabled = selectedGender.map { _ in true }

    input.nextBtnTap
      .throttle(.milliseconds(500), latest: false)
      .withLatestFrom(selectedGender)
      .drive(with: self) { owner, selectedGender in
        owner.pendingUser.preferGender = selectedGender
        owner.useCase.savePendingUser(owner.pendingUser)
        owner.delegate?.invoke(.nextAtPreferGender, owner.pendingUser)
      }.disposed(by: disposeBag)

    return Output(
      isNextBtnEnabled: nextBtnisEnabled,
      initialGender: initialGender
    )
  }
}
