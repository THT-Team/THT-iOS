//
//  PhoneNumberAuthVM.swift
//  MyPageInterface
//
//  Created by kangho lee on 7/27/24.
//

import Foundation

import DSKit
import AuthInterface
import MyPageInterface
import Domain

final class PhoneNumberAuthVM: AuthViewModelType {
  
  private let phoneNumber: String
  private let useCase: MyPageUseCaseInterface
  private let authUseCase: AuthUseCaseInterface
  private var disposeBag = DisposeBag()
  weak var delegate: PhoneAuthViewDelegate?
  
  struct Input: AuthInput {
    let viewWillAppear: Signal<Void>
    let codeInput: Driver<String>
    let finishAnimationTrigger: Signal<Void>
    let resendBtnTap: Signal<Void>
  }
  
  struct Output: AuthOutput {
    let description: Driver<String>
    let error: Driver<Error>
    let certificateSuccess: Driver<Bool>
    let certificateFailuer: Driver<Bool>
    let timestamp: Driver<String>
  }
  
  init(phoneNumber: String, useCase: MyPageUseCaseInterface, authUseCase: AuthUseCaseInterface) {
    self.phoneNumber = phoneNumber
    self.useCase = useCase
    self.authUseCase = authUseCase
  }
  
  func transform(input: Input) -> Output {
    let errorTracker = PublishSubject<Error>()
    let description = Driver.just(phoneNumber + "으로\n전송된 코드를 입력해주세요.")
    
    let timeDuration = 10
    let timer = Observable<Int>.timer(.seconds(0), period: .seconds(1), scheduler: MainScheduler.instance)
      .debug("tick")
      .take(timeDuration + 2)
    
    let authNumber = Signal.merge(input.resendBtnTap, input.viewWillAppear)
      .flatMapLatest { [weak self] _ -> Driver<Int> in
        guard let self else { return .empty() }
        
        return self.authUseCase.certificate(phoneNumber: self.phoneNumber)
          .debug()
          .asDriver { error in
            errorTracker.onNext(error)
            return .empty()
          }
      }
    
    let timestampModel = authNumber.map { AuthCodeWithTimeStamp(authCode: $0, timeDuration: timeDuration) }
    
    let isValidate = input.codeInput
      .distinctUntilChanged()
      .filter { $0.count == 6 }
      .withLatestFrom(timestampModel) { code, authNumber in
        guard authNumber.isAvailableCode() else {
          return false
        }
        return code == String(authNumber.authCode)
      }
    
    Driver.zip(isValidate, input.finishAnimationTrigger.asDriver(onErrorDriveWith: .empty())) { validate, _ in validate }
      .filter { $0 }
      .flatMapLatest(with: self) { owner, _ in
        owner.useCase.updatePhoneNumber(owner.phoneNumber)
          .asDriver { error in
            errorTracker.onNext(error)
            return .empty()
          }
      }.drive(with: self) { owner, _ in
        owner.delegate?.didAuthComplete(option: .none)
      }.disposed(by: disposeBag)
    
    let timestamp = authNumber
      .flatMapLatest({ _ in
        timer.asDriverOnErrorJustEmpty()
      })
      .withLatestFrom(timestampModel) { $1.timeString }
    
    return Output(
      description: description,
      error: errorTracker.asDriver(onErrorDriveWith: .empty()),
      certificateSuccess: isValidate.filter { $0 },
      certificateFailuer: isValidate.filter { !$0 },
      timestamp: timestamp
    )
  }
}
