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

enum Gender: Int {
  case male
  case female
  case both
}

final class GenderPickerViewModel: ViewModelType {
  weak var delegate: SignUpCoordinatingActionDelegate?

  struct Input {
    var genderTap: Driver<Gender>
    var birthdayTap: Driver<Void>
    var nextBtnTap: Driver<Void>
  }

  struct Output {
    var birthday: Driver<String>
    var isNextBtnEnabled: Driver<Bool>
  }

  private var disposeBag = DisposeBag()

  private var selectedBirthday = PublishRelay<Date>()

  func transform(input: Input) -> Output {
    let selectedGender = input.genderTap
    let birthday = self.selectedBirthday.asDriverOnErrorJustEmpty()
      .startWith("".toDate())
      .debug("birthday")
    // TODO: 성년으로 초기화날짜

    let nextBtnisEnabled = Driver.combineLatest(
      selectedGender.map { _ in },
      birthday.map { _ in }
    ) { _, _ in
      return true
    }

    input.birthdayTap
      .withLatestFrom(birthday)
      .debug("tapped")
      .drive(with: self) { owner, birthday in
        owner.delegate?.invoke(.birthdayTap(birthday: birthday, listener: owner))
      }.disposed(by: disposeBag)

    input.nextBtnTap
      .drive(with: self) { owner, _ in
        owner.delegate?.invoke(.nextAtGender)
      }.disposed(by: disposeBag)

    let formattedBirthday = birthday.map {
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy.MM.dd"
      let formatted = formatter.string(from: $0)
      return formatted
    }

    return Output(
      birthday: formattedBirthday,
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
