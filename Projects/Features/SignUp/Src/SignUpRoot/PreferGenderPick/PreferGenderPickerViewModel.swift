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
  private let userInfoUseCase: UserInfoUseCaseInterface

  struct Input {
    let viewWillAppear: Driver<Void>
    var genderTap: Driver<Gender>
    var nextBtnTap: Driver<Void>
  }

  struct Output {
    var isNextBtnEnabled: Driver<Bool>
    var initialGender: Driver<Gender>
  }

  private var disposeBag = DisposeBag()

  init(userInfoUseCase: UserInfoUseCaseInterface) {
    self.userInfoUseCase = userInfoUseCase
  }

  deinit {
    print("deinit: PreferGenderPickerViewModel")
  }

  func transform(input: Input) -> Output {

    let userinfo = input.viewWillAppear
      .asObservable()
      .withUnretained(self)
      .flatMap { owner, _ in
        owner.userInfoUseCase.fetchUserInfo()
          .catchAndReturn(UserInfo(phoneNumber: ""))
          .asObservable()
      }
      .asDriverOnErrorJustEmpty()
      .debug("fetched UserInfo")

    let initialGender = userinfo.map { $0.preferGender }
      .compactMap { $0 }
      .debug("fetched preferGender")

    let selectedGender = input.genderTap
      .debug("tapped Gender")

    let nextBtnisEnabled = selectedGender.map { _ in true }

    input.nextBtnTap
      .throttle(.milliseconds(500), latest: false)
      .withLatestFrom(selectedGender)
      .debug("toSave preferGender")
      .withLatestFrom(userinfo) { preferGender, info in
        var mutable = info
        mutable.preferGender = preferGender
        print("mutable - preferGender: \(preferGender)")
        return mutable
      }
      .drive(with: self) { owner, userinfo in
        owner.userInfoUseCase.updateUserInfo(userInfo: userinfo)
        owner.delegate?.invoke(.nextAtPreferGender)
      }.disposed(by: disposeBag)

    return Output(
      isNextBtnEnabled: nextBtnisEnabled,
      initialGender: initialGender
    )
  }
}
