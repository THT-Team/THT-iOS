//
//  IdealTypeViewModel.swift
//  SignUpInterface
//
//  Created by Kanghos on 2024/04/24.
//

import Foundation

import Core
import SignUpInterface

import RxSwift
import RxCocoa
import DSKit
import Domain

open class BaseTagPickerViewModel: BasePenddingViewModel {
  let userDomainUseCase: UserDomainUseCaseInterface

  init(useCase: SignUpUseCaseInterface, pendingUser: PendingUser, userDomainUseCase: UserDomainUseCaseInterface) {
    self.userDomainUseCase = userDomainUseCase
    super.init(useCase: useCase, pendingUser: pendingUser)
  }
}

final class IdealTypeTagPickerViewModel: BaseTagPickerViewModel, ViewModelType {

  struct Input {
    var chipTap: Driver<IndexPath>
    var nextBtnTap: Driver<Void>
  }

  struct Output {
    var chips: Driver<[InputTagItemViewModel]>
    var isNextBtnEnabled: Driver<Bool>
  }

  func transform(input: Input) -> Output {

    let chips = BehaviorRelay<[InputTagItemViewModel]>(value: [])

    userDomainUseCase.fetchEmoji(initial: pendingUser.idealTypeList, type: .idealType)
      .asDriver(onErrorJustReturn: [])
      .drive(chips)
      .disposed(by: disposeBag)

    input.chipTap.map { $0.item }
      .withLatestFrom(chips.asDriver()) { index, chips in
        var prev = chips.enumerated().filter { $0.element.isSelected }.map { $0.offset }

        if prev.contains(index) {
          prev.removeAll { $0 == index }
        } else if prev.count < 3 {
          prev.append(index)
        }
        var mutable = chips.map {
          var model = $0
          model.isSelected = false
          return model
        }

        prev.forEach { index in
          mutable[index].isSelected = true
        }

        return mutable
      }.drive(chips)
      .disposed(by: disposeBag)

    let isNextBtnEnabled = chips.asDriver()
      .map { $0.filter { $0.isSelected }.count == 3 }

    input.nextBtnTap
      .withLatestFrom(isNextBtnEnabled)
      .filter { $0 }
      .withLatestFrom(chips.asDriver()) { _, chips in
        chips.filter { $0.isSelected }.map { $0.emojiType.idx }
      }
      .drive(with: self, onNext: { owner, chips in
        owner.pendingUser.idealTypeList = chips
        owner.useCase.savePendingUser(owner.pendingUser)
        owner.delegate?.invoke(.nextAtIdealType, owner.pendingUser)
      })
      .disposed(by: disposeBag)

    return Output(
      chips: chips.asDriver(),
      isNextBtnEnabled: isNextBtnEnabled
    )
  }
}
