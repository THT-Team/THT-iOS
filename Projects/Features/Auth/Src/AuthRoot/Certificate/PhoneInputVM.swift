//
//  PhoneInputVM.swift
//  Auth
//
//  Created by kangho lee on 7/26/24.
//

import Foundation

import AuthInterface
import Core
import Domain

public final class PhoneInputVM: ViewModelType, PhoneNumberVMType {
  public weak var delegate: PhoneInputVCDelegate?
  
  public struct Input {
    let phoneNum: Driver<String>
    let verifyBtn: Driver<String>
  }
  
  public struct Output {
    let validate: Driver<Bool>
    let errorMessage: Driver<String>
    let initialValue: Driver<String>
  }

  private var disposeBag = DisposeBag()
  private let useCase: AuthUseCaseInterface

  public init(delegate: PhoneInputVCDelegate, useCase: AuthUseCaseInterface) {
    self.delegate = delegate
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
        owner.delegate?.didTapPhoneInputBtn(phone)
      }.disposed(by: disposeBag)
    
    return Output(
      validate: isVerifyBtnEnabled,
      errorMessage: errorMessage,
      initialValue: initialPhoneNumber
    )
  }
}
