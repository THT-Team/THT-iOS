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

final class AlcoholTobaccoPickerViewModel: BasePenddingViewModel, ViewModelType {

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

  func transform(input: Input) -> Output {

    let smoke = Driver.just(pendingUser).compactMap(\.smoking).map { FrequencyType.smoking($0) }
    let drink = Driver.just(pendingUser).compactMap { $0.drinking }.map { FrequencyType.drinking($0) }

    let initialFrequency = Driver.concat([smoke, drink])

    let selectedTobacco = input.tobaccoTap
    let selectedAlcohol = input.alcoholTap

    let alcoholAndTobacco = Driver.combineLatest(selectedAlcohol, selectedTobacco)

    let nextBtnisEnabled = alcoholAndTobacco.map { _ in true }.startWith(false)

    input.nextBtnTap
      .withLatestFrom(nextBtnisEnabled)
      .filter { $0 }
      .throttle(.milliseconds(500), latest: false)
      .withLatestFrom(alcoholAndTobacco)
      .drive(with: self) { owner, frequencies in
        let (drink, smoke) = frequencies
        owner.pendingUser.smoking = smoke
        owner.pendingUser.drinking = drink
        owner.useCase.savePendingUser(owner.pendingUser)
        owner.delegate?.invoke(.nextAtAlcoholTobacco, owner.pendingUser)
      }.disposed(by: disposeBag)

    return Output(
      isNextBtnEnabled: nextBtnisEnabled,
      initialFrequecy: initialFrequency
    )
  }
}
