//
//  HeightVIewModel.swift
//  SignUp
//
//  Created by Kanghos on 2024/04/21.
//

import Foundation

import Core
import DSKit
import SignUpInterface

import RxSwift
import RxCocoa

final class HeightPickerViewModel: BasePenddingViewModel, ViewModelType {

  struct Input {
    var pickerLabelTap: Driver<Void>
    var nextBtnTap: Driver<Void>
  }

  struct Output {
    var height: Driver<String>
    var isNextBtnEnabled: Driver<Bool>
  }

  private let defaultHeight = 145
  private lazy var selectedHeight = BehaviorRelay<Int>(value: defaultHeight)

  func transform(input: Input) -> Output {
    
    Driver.just(pendingUser)
      .compactMap(\.tall)
      .drive(selectedHeight)
      .disposed(by: disposeBag)

    let height = self.selectedHeight.asDriver()

    let nextBtnisEnabled = height
      .map { _ in return true }

    input.pickerLabelTap
      .withLatestFrom(height)
      .drive(with: self) { owner, height in
        owner.delegate?.invoke(.heightLabelTap(height, listener: owner), owner.pendingUser)
      }.disposed(by: disposeBag)

    input.nextBtnTap
      .withLatestFrom(nextBtnisEnabled)
      .filter { $0 }
      .throttle(.milliseconds(500), latest: false)
      .withLatestFrom(height)
      .drive(with: self) { owner, height in
        owner.pendingUser.tall = height
        owner.useCase.savePendingUser(owner.pendingUser)
        owner.delegate?.invoke(.nextAtHeight, owner.pendingUser)
      }.disposed(by: disposeBag)

    return Output(
      height: height.map { String($0) + " cm" },
      isNextBtnEnabled: nextBtnisEnabled
    )
  }
}

extension HeightPickerViewModel: BottomSheetListener {
  func sendData(item: BottomSheetValueType) {
    if case let .text(text) = item {
      self.selectedHeight.accept(Int(text) ?? defaultHeight)
    }
  }
}
