//
//  HeightVIewModel.swift
//  SignUp
//
//  Created by Kanghos on 2024/04/21.
//

import Foundation

import Core
import SignUpInterface

import RxSwift
import RxCocoa

final class HeightPickerViewModel: ViewModelType {
  weak var delegate: SignUpCoordinatingActionDelegate?

  struct Input {
    var pickerLabelTap: Driver<Void>
    var nextBtnTap: Driver<Void>
  }

  struct Output {
    var height: Driver<String>
    var isNextBtnEnabled: Driver<Bool>
  }

  private var disposeBag = DisposeBag()

  private var selectedHeight = BehaviorRelay<Int>(value: 145)

  func transform(input: Input) -> Output {
    let height = self.selectedHeight
      .asDriver()

    let nextBtnisEnabled = height.skip(1)
      .map { _ in return true }

    input.pickerLabelTap
      .withLatestFrom(height)
      .drive(with: self) { owner, height in
        owner.delegate?.invoke(.heightLabelTap(height, listener: owner))
      }.disposed(by: disposeBag)

    input.nextBtnTap
      .withLatestFrom(height)
      .drive(with: self) { owner, height in
        owner.delegate?.invoke(.nextAtHeight(height))
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
      self.selectedHeight.accept(Int(text) ?? 145)
    }
  }
}
