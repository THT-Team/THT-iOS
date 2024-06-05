//
//  AlcoholTobaccoInputViewModel.swift
//  SignUp
//
//  Created by Kanghos on 2024/04/21.
//

import Foundation

import Core
import SignUpInterface

import RxSwift
import RxCocoa

final class AlcoholTobaccoPickerViewModel: ViewModelType {
  weak var delegate: SignUpCoordinatingActionDelegate?
  private let userInfoUseCase: UserInfoUseCaseInterface

  struct Input {
    var tobaccoTap: Driver<Frequency>
    var alcoholTap: Driver<Frequency>
    var nextBtnTap: Driver<Void>
  }

  struct Output {
    var isNextBtnEnabled: Driver<Bool>
    let initialFrequecy: Driver<FrequencyType>
  }

  enum FrequencyType {
    case smoking(Frequency)
    case drinking(Frequency)
  }

  private var disposeBag = DisposeBag()

  init(userInfoUseCase: UserInfoUseCaseInterface) {
    self.userInfoUseCase = userInfoUseCase
  }

  func transform(input: Input) -> Output {
    let userinfo = Driver.just(())
      .asObservable()
      .withUnretained(self)
      .flatMap { owner, _ in
        owner.userInfoUseCase.fetchUserInfo()
          .catchAndReturn(UserInfo(phoneNumber: ""))
          .asObservable()
      }
      .asDriverOnErrorJustEmpty()
      .debug("userinfo")

    let smoke = userinfo.compactMap { $0.smoking }.map { FrequencyType.smoking($0) }
    let drink = userinfo.compactMap { $0.drinking }.map { FrequencyType.drinking($0) }

    let initialFrequency = Driver.concat([smoke, drink])

    let selectedTobacco = input.tobaccoTap
    let selectedAlcohol = input.alcoholTap

    let nextBtnisEnabled = Driver.combineLatest(selectedAlcohol, selectedTobacco).map { _ in true }

    let updatedUserInfo = Driver.combineLatest(selectedAlcohol, selectedTobacco) { ($0, $1) }
      .withLatestFrom(userinfo) { component, userinfo in
        let (drink, smoke) = component
        var mutable = userinfo
        mutable.smoking = smoke
        mutable.drinking = drink
        return mutable
      }

    input.nextBtnTap
      .withLatestFrom(nextBtnisEnabled)
      .filter { $0 }
      .map { _ in }
      .throttle(.milliseconds(500), latest: false)
      .withLatestFrom(updatedUserInfo)
      .drive(with: self) { owner, userinfo in
        owner.userInfoUseCase.updateUserInfo(userInfo: userinfo)
        owner.delegate?.invoke(.nextAtAlcoholTobacco)
      }.disposed(by: disposeBag)

    return Output(
      isNextBtnEnabled: nextBtnisEnabled,
      initialFrequecy: initialFrequency
    )
  }
}
