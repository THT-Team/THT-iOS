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
  weak var delegate: MySettingCoordinatingActionDelegate?

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
        owner.delegate?.invoke(.showLogoutAlert(self))
      }
      .disposed(by: disposeBag)

    input.deactivateTap
      .drive(with: self) { owner, _ in
        owner.delegate?.invoke(.showDeactivateAlert(self))
      }.disposed(by: disposeBag)
    return Output(toast: toast.asDriverOnErrorJustEmpty())
  }
}

extension AccountSettingViewModel: LogoutListenr {
  func logoutTap() {

  }
}

extension AccountSettingViewModel: DeactivateListener {
  func deactivateTap() {

  }
}
