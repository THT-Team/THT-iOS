//
//  GenderPickerViewModel.swift
//  SignUpInterface
//
//  Created by Kanghos on 2024/04/16.
//

import Foundation

import Core
import SignUpInterface

import RxSwift
import RxCocoa
import DSKit
import Domain

final class GenderPickerViewModel: BasePenddingViewModel, ViewModelType {

  struct Input {
    var genderTap: Driver<Gender>
    var birthdayTap: Driver<Void>
    var nextBtnTap: Driver<Void>
  }

  struct Output {
    var initialGender: Driver<Gender?>
    var birthday: Driver<String>
    var isNextBtnEnabled: Driver<Bool>
  }

  private var selectedBirthday = PublishRelay<Date?>()

  func transform(input: Input) -> Output {
    let penddingUserShare = Driver.just(self.pendingUser)

    let initialGender = penddingUserShare.map { $0.gender }
    let initialBirthday = penddingUserShare.map { $0.birthday?.toDate() }

    let selectedGender = Driver.merge(input.genderTap, initialGender.compactMap { $0 })
    let birthday = Driver.merge(self.selectedBirthday.asDriverOnErrorJustEmpty(), initialBirthday)
      .map { $0 ?? Date.currentAdultDateOrNil() ?? Date() }

    let nextBtnisEnabled = Driver.zip(selectedGender, birthday).map { _ in true }

    input.birthdayTap
      .withLatestFrom(birthday)
      .debug("tapped")
      .drive(with: self) { owner, birthday in
        owner.delegate?.invoke(.birthdayTap(birthday, listener: owner), owner.pendingUser)
      }.disposed(by: disposeBag)

    input.nextBtnTap
      .throttle(.milliseconds(500), latest: false)
      .withLatestFrom(birthday)
      .withLatestFrom(selectedGender) { (date: $0, gender: $1) }
      .drive(with: self) { owner, component in
        let (date, gender) = component
        owner.pendingUser.birthday = date.toYMDDotDateString()
        owner.pendingUser.gender = gender
        owner.useCase.savePendingUser(owner.pendingUser)
        owner.delegate?.invoke(.nextAtGender, owner.pendingUser)
      }.disposed(by: disposeBag)

    return Output(
      initialGender: initialGender,
      birthday: birthday.map { $0.toYMDDotDateString() },
      isNextBtnEnabled: nextBtnisEnabled
    )
  }
}

extension GenderPickerViewModel: BottomSheetListener {
  func sendData(item: BottomSheetValueType) {
    if case let .date(selectedDate) = item {
      self.selectedBirthday.accept(selectedDate)
    }
  }
}
