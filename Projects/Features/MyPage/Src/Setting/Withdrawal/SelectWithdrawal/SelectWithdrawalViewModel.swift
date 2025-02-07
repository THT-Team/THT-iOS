//
//  SelectWithdrawalViewModel.swift
//  MyPage
//
//  Created by Kanghos on 7/3/24.
//

import Foundation

import RxSwift
import RxCocoa

import Core

import MyPageInterface

public final class SelectWithdrawalViewModel: ViewModelType {
  var onSelect: ((WithdrawalReason) -> Void)?

  public struct Input {
    let load: Driver<Void>
    let selectModel: Driver<WithdrawalReason>
  }

  public struct Output {
    let models: Driver<[WithdrawalReason]>
  }

  private var disposeBag = DisposeBag()

  public func transform(input: Input) -> Output {
    let models = input.load
      .map { _ -> [WithdrawalReason] in
        [.stop, .matched, .disLikeApp, .newStart, .problem, .other]
      }

    input.selectModel
      .debug()
      .drive(with: self) { owner, reason in
        owner.onSelect?(reason)
      }.disposed(by: disposeBag)

    return Output(models: models)
  }
}
