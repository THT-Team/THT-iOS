//
//  PhoneInputVM.swift
//  Auth
//
//  Created by Kanghos on 12/16/24.
//

import Foundation

import AuthInterface
import Core
import RxSwift
import RxCocoa

public final class PhoneNumberInputVM: PhoneNumberViewModelType {
  public var onBackButtonTap: (() -> Void)?
  public var onPhoneNumberInput: ((String) -> Void)?

  public struct Input {
    let phoneNum: Driver<String>
    let verifyBtn: Driver<String>
    let backButtonTap: Driver<Void>
  }

  public struct Output {
    let validate: Driver<Bool>
    let errorMessage: Driver<String>
    let initialValue: Driver<String>
  }

  private var disposeBag = DisposeBag()
  private let useCase: AuthUseCaseInterface

  public init(useCase: AuthUseCaseInterface) {
    self.useCase = useCase
  }

  public func transform(input: Input) -> Output {
    let initialPhoneNumber = Driver.just(useCase.fetchPhoneNumber() ?? "")
      .debug("saved phoneNumber")
      .filter { !$0.isEmpty }
    let isVerifyBtnEnabled = input.phoneNum
      .map { $0.phoneNumValidation() }

    let errorMessage = isVerifyBtnEnabled
      .filter { !$0 }
      .map { _ in "핸드폰 번호를 다시 확인 해 주세요." }

    input.verifyBtn
      .withLatestFrom(isVerifyBtnEnabled)
      .filter { $0 }
      .throttle(.milliseconds(500), latest: false)
      .withLatestFrom(input.phoneNum)
      .drive(with: self) { owner, phone in
        owner.useCase.savePhoneNumber(phone)
        owner.onPhoneNumberInput?(phone)
      }.disposed(by: disposeBag)

    input.backButtonTap
      .drive(with: self) { owner, _ in
        owner.onBackButtonTap?()
      }.disposed(by: disposeBag)

    return Output(
      validate: isVerifyBtnEnabled,
      errorMessage: errorMessage,
      initialValue: initialPhoneNumber
    )
  }
}
