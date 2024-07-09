//
//  LauncherViewModel.swift
//  AuthDemo
//
//  Created by Kanghos on 6/4/24.
//

import Foundation

import AuthInterface
import SignUpInterface
import Core

import RxSwift
import RxCocoa

protocol LauncherDelegate: AnyObject {
  func needAuth()
  func toMain()
}

public final class LauncherViewModel: ViewModelType {
  private var disposeBag = DisposeBag()
  private let userInfoUseCase: UserInfoUseCaseInterface
  private let useCase: AuthUseCaseInterface
  weak var delegate: LauncherDelegate?

  public struct Input {
    let viewDidLoad: Driver<Void>
  }

  public struct Output {
    let state: Driver<Void>
    let toast: Signal<String>
  }

  public init(userInfoUseCase: UserInfoUseCaseInterface, useCase: AuthUseCaseInterface) {
    self.userInfoUseCase = userInfoUseCase
    self.useCase = useCase
  }

  deinit {
    TFLogger.cycle(name: self)
  }

  public func transform(input: Input) -> Output {
    let toast = PublishRelay<String>()

    let phoneNumber = userInfoUseCase.fetchPhoneNumber()
      .asDriver(onErrorJustReturn: "")

    let needAuth = input.viewDidLoad
      .withLatestFrom(phoneNumber)
      .map { $0.isEmpty }

      needAuth
      .filter { $0 }
      .drive(with: self) { owner, needAuth in
        owner.delegate?.needAuth()
      }.disposed(by: disposeBag)

    needAuth
      .filter { !$0 }
      .withLatestFrom(phoneNumber)
      .flatMapLatest(with: self) { owner, phoneNum in
        owner.useCase.login(phoneNumber: phoneNum, deviceKey: "device")
          .debug("login")
          .asDriver(onErrorRecover: { error in
            TFLogger.dataLogger.error("\(error.localizedDescription)")
            toast.accept("로그인에 실패하였습니다. 다시 시도해주시기 바랍니다.\n\(error.localizedDescription)")
            return .empty()
          })
      }.drive(with: self) { owner, _ in
        owner.delegate?.toMain()
      }.disposed(by: disposeBag)

    return Output(
      state: Driver.just(()),
      toast: toast.asSignal()
    )
  }
}
