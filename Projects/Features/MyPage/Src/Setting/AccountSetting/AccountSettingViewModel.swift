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

public final class AccountSettingViewModel: ViewModelType {
  private var disposeBag = DisposeBag()
  private let useCase: MyPageUseCaseInterface

  // MARK: Coordinator
  var showLogOutAlert: ((AlertHandler) -> Void)?
  var showDeactivateAlert: ((AlertHandler) -> Void)?
  var onRoot: (() -> Void)?
  var onWithDrawal: (() -> Void)?

  public init(useCase: MyPageUseCaseInterface) {
    self.useCase = useCase
  }

  deinit {
    TFLogger.cycle(name: self)
  }

  public struct Input {
    let tap: Driver<Void>
    let deactivateTap: Driver<Void>
  }

  public struct Output {
    let toast: Driver<String>
  }

  public func transform(input: Input) -> Output {
    let toast = PublishSubject<String>()
    let accountAlertSignal = PublishRelay<Void>()

    input.tap
      .drive(with: self) { owner, _ in
        owner.showLogOutAlert? {
          accountAlertSignal.accept(())
        }
      }
      .disposed(by: disposeBag)

    input.deactivateTap
      .drive(with: self) { owner, _ in
        owner.showDeactivateAlert? {
          owner.onWithDrawal?()
        }
      }.disposed(by: disposeBag)

    accountAlertSignal
      .withUnretained(self)
      .flatMap { owner, _ in
        owner.useCase.logout()
          .debug()
          .asObservable()
      }
      .asDriverOnErrorJustEmpty()
      .drive(with: self) { owner, _ in
        NotificationCenter.default.post(Notification(name: .needAuthLogout))
      }.disposed(by: disposeBag)

    return Output(toast: toast.asDriverOnErrorJustEmpty())
  }
}
