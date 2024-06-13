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

final class GenderPickerViewModel: ViewModelType {
  weak var delegate: SignUpCoordinatingActionDelegate?

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

  private var disposeBag = DisposeBag()

  private var selectedBirthday = PublishRelay<Date?>()
  private let userInfoUseCase: UserInfoUseCaseInterface

  init(userInfoUseCase: UserInfoUseCaseInterface) {
    self.userInfoUseCase = userInfoUseCase
  }

  func transform(input: Input) -> Output {

    let userInfo = Observable.just(())
      .withUnretained(self)
      .flatMap { owner, _ in
        owner.userInfoUseCase.fetchUserInfo()
          .catchAndReturn(UserInfo(phoneNumber: ""))
          .asObservable()
      }
      .asDriverOnErrorJustEmpty()

    let initialGender = userInfo.map { $0.gender }
    let initialBirthday = userInfo.map { $0.birthday?.toDate() }

    let selectedGender = Driver.merge(input.genderTap, initialGender.compactMap { $0 })
    let birthday = Driver.merge(self.selectedBirthday.asDriverOnErrorJustEmpty(), initialBirthday)
      .map { $0 ?? Date.currentAdultDateOrNil() ?? Date() }

    let nextBtnisEnabled = Driver.zip(selectedGender, birthday).map { _ in true }

    input.birthdayTap
      .withLatestFrom(birthday)
      .debug("tapped")
      .drive(with: self) { owner, birthday in
        owner.delegate?.invoke(.birthdayTap(birthday, listener: owner))
      }.disposed(by: disposeBag)

    input.nextBtnTap
      .throttle(.milliseconds(500), latest: false)
      .withLatestFrom(birthday)
      .withLatestFrom(selectedGender) { (date: $0, gender: $1) }
      .withLatestFrom(userInfo) { info, userInfo in
        var mutable = userInfo
        mutable.birthday = info.date.toYMDDotDateString()
        mutable.gender = info.gender
        return mutable
      }
      .drive(with: self) { owner, userinfo in
        owner.userInfoUseCase.updateUserInfo(userInfo: userinfo)
        owner.delegate?.invoke(.nextAtGender)
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
