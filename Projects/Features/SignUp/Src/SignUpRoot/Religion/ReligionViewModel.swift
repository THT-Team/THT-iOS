//
//  ReligionViewModel.swift
//  SignUpInterface
//
//  Created by Kanghos on 2024/04/25.
//

import Foundation

import Core

import RxSwift
import RxCocoa
import Domain
import SignUpInterface

final class ReligionPickerViewModel: BasePenddingViewModel, ViewModelType {

  struct Input {
    var chipTap: Driver<IndexPath>
    var nextBtnTap: Driver<Void>
  }

  struct Output {
    var chips: Driver<[(Religion, Bool)]>
    var isNextBtnEnabled: Driver<Bool>
  }

  func transform(input: Input) -> Output {

    let initialReligion = Driver.just(self.pendingUser.religion).compactMap { $0 }

    let chips = BehaviorRelay<[(Religion, Bool)]>(value: Religion.allCases.map { ($0, false) })

    initialReligion
      .withLatestFrom(chips.asDriver()) { initial, chips in
        var mutable = chips
        guard let index = chips.firstIndex(where: { (item, _) in
          item == initial
        }) else { return mutable}
        mutable[index] = (initial, true)
        return mutable
      }
      .drive(chips)
      .disposed(by: disposeBag)

    input.chipTap
      .withLatestFrom(chips.asDriver()) { indexPath, array in
        var mutable = array.map { ($0.0, false) }
        mutable[indexPath.row] = (mutable[indexPath.row].0, true)
        return mutable
      }
      .debug("tap chips")
      .drive(chips)
      .disposed(by: disposeBag)

    let selectedChip = chips
      .asDriver()
      .map {
      $0.first { (_, isSelected) in
        isSelected
      }.map { $0.0 }
    }.compactMap { $0 }

    let isNextBtnEnabled = chips
      .asDriver()
      .map { $0.map { $0.1 } }
      .map {  
        $0.filter { $0 == true }.count == 1
      }

    input.nextBtnTap
      .withLatestFrom(isNextBtnEnabled)
      .filter { $0 }
      .withLatestFrom(selectedChip)
      .drive(with: self, onNext: { owner, selected in
        owner.pendingUser.religion = selected
        owner.useCase.savePendingUser(owner.pendingUser)
        owner.delegate?.invoke(.nextAtReligion, owner.pendingUser)
        })
      .disposed(by: disposeBag)

    return Output(
      chips: chips.asDriver(),
      isNextBtnEnabled: isNextBtnEnabled
    )
  }
}

extension Religion {
  public static var allCases: [Religion] = [
    .none, .christian, .buddhism,
    .catholic, .wonBuddhism, .other
  ]

  public var label: String {
    switch self {
    case .none: return "무교"
    case .christian: return "기독교"
    case .buddhism: return "불교"
    case .catholic: return "천주교"
    case .wonBuddhism: return "원불교"
    case .other: return "기타"
    }
  }
}
