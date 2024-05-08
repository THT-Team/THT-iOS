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

  struct Input {
    var tobaccoTap: Driver<Int>
    var alcoholTap: Driver<Int>
    var nextBtnTap: Driver<Void>
  }

  struct Output {
    var isNextBtnEnabled: Driver<Bool>
  }

  private var disposeBag = DisposeBag()

  func transform(input: Input) -> Output {
    let selectedTobacco = input.tobaccoTap
    let selectedAlcohol = input.alcoholTap

    let nextBtnisEnabled = Driver.combineLatest(selectedAlcohol, selectedTobacco).map { _ in true }

    input.nextBtnTap
      .withLatestFrom(nextBtnisEnabled)
      .filter { $0 }
      .drive(with: self) { owner, _ in
        owner.delegate?.invoke(.nextAtAlcoholTobacco(alcoho: .frequently, tobacco: .frequently))
      }.disposed(by: disposeBag)

    return Output(
      isNextBtnEnabled: nextBtnisEnabled
    )
  }
}
