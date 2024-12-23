//
//  AccountSettingViewModel.swift
//  MyPageInterface
//
//  Created by Kanghos on 6/13/24.
//


import Foundation

import Core

import RxSwift
import RxCocoa

import MyPageInterface

final class AccountSettingViewModel: ViewModelType {
  private var disposeBag = DisposeBag()
  private let useCase: MyPageUseCaseInterface
  private let accountAlertSignal = PublishRelay<Void>()

  // MARK: Coordinator
  var showLogOutAlert: ((AlertHandler) -> Void)?
  var showDeactivateAlert: ((AlertHandler) -> Void)?
  var onRoot: (() -> Void)?
  var onWithDrawal: (() -> Void)?

  init(useCase: MyPageUseCaseInterface) {
    self.useCase = useCase
  }

  struct Input {
    let tap: Driver<Void>
    let deactivateTap: Driver<Void>
  }

  struct Output {
    let toast: Driver<String>
  }

  func transform(input: Input) -> Output {
    let toast = PublishSubject<String>()

    input.tap
      .drive(with: self) { owner, _ in
        owner.showLogOutAlert? {
          owner.accountAlertSignal.accept(())
        }
//        owner.delegate?.invoke(.showLogoutAlert(self))
      }
      .disposed(by: disposeBag)

    input.deactivateTap
      .drive(with: self) { owner, _ in
        owner.showDeactivateAlert? {
          owner.onWithDrawal?()
        }
//        owner.delegate?.invoke(.showDeactivateAlert(self))
      }.disposed(by: disposeBag)

    self.accountAlertSignal.asSignal()
      .flatMap({ [weak self] _ -> Signal<Void> in
        guard let self else { return Signal.empty() }
        return self.useCase.logout()
          .asSignal { error -> Signal<Void> in
            return .just(())
          }
      })
      .emit(with: self) { owner, _ in
        owner.onRoot?()
//        owner.delegate?.invoke(.toRoot)
      }.disposed(by: disposeBag)

    return Output(toast: toast.asDriverOnErrorJustEmpty())
  }
}
