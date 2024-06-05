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
  }

  public init(userInfoUseCase: UserInfoUseCaseInterface, useCase: AuthUseCaseInterface) {
    self.userInfoUseCase = userInfoUseCase
    self.useCase = useCase
  }

  public func transform(input: Input) -> Output {

    let phoneNumber = userInfoUseCase.fetchPhoneNumber()
      .catchAndReturn("")
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
      .asObservable()
      .withLatestFrom(phoneNumber)
      .withUnretained(self)
      .flatMap { owner, phoneNum in
        owner.useCase.login(phoneNumber: phoneNum, deviceKey: "device")
          .asObservable()
          .catch { error in
            TFLogger.dataLogger.error("\(error.localizedDescription)")
            return .empty()
          }
      }.subscribe(with: self) { owner, _ in
        owner.delegate?.toMain()
      }.disposed(by: disposeBag)

    return Output(state: Driver.just(()))
  }
}
