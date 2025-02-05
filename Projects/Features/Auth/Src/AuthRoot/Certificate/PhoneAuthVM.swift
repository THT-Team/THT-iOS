//
//  PhoneAuthVM.swift
//  Auth
//
//  Created by kangho lee on 7/26/24.
//

import Foundation

import DSKit
import AuthInterface
import Domain

public final class PhoneAuthVM: AuthViewModelType {
  private let phoneNumber: String
  private let useCase: AuthUseCaseInterface
  private var disposeBag = DisposeBag()
  public weak var delegate: PhoneAuthViewDelegate?
  
  public struct Input: AuthInput {
    public let viewWillAppear: Signal<Void>
    public let codeInput: Driver<String>
    public let finishAnimationTrigger: Signal<Void>
    public let resendBtnTap: Signal<Void>

    public init(viewWillAppear: Signal<Void>, codeInput: Driver<String>, finishAnimationTrigger: Signal<Void>, resendBtnTap: Signal<Void>) {
      self.viewWillAppear = viewWillAppear
      self.codeInput = codeInput
      self.finishAnimationTrigger = finishAnimationTrigger
      self.resendBtnTap = resendBtnTap
    }
  }
  
  public struct Output: AuthOutput {
    public let description: Driver<String>
    public let error: Driver<Error>
    public let certificateSuccess: Driver<Bool>
    public let certificateFailuer: Driver<Bool>
    public let timestamp: Driver<String>
  }
  
  public init(phoneNumber: String, delegate: PhoneAuthViewDelegate, useCase: AuthUseCaseInterface) {
    self.phoneNumber = phoneNumber
    self.useCase = useCase
    self.delegate = delegate
  }

  deinit {
    self.timerDisposable?.dispose()
    self.timerDisposable = nil
  }

  var timerDisposable: Disposable?

  let timerTrigger = PublishSubject<Void>()
  let tickTrigger = PublishSubject<Void>()
  public func transform(input: Input) -> Output {
    let timeDuration = 180
    let errorTracker = PublishSubject<Error>()
    let description = Driver.just(phoneNumber + "으로\n전송된 코드를 입력해주세요.")

    let authNumber = Signal.merge(input.resendBtnTap, input.viewWillAppear)
      .flatMapLatest { [weak self] _ -> Driver<Int> in
        guard let self else { return .empty() }
        self.releaseTimer()
        self.startTimer(timeDuration: timeDuration)

        return self.useCase.certificate(phoneNumber: self.phoneNumber)
          .debug()
          .asDriver { error in
            errorTracker.onNext(error)
            return .empty()
          }
      }
    
    let timestampModel = authNumber
      .map { AuthCodeWithTimeStamp(
        authCode: $0,
        timeDuration: timeDuration)}

    let isValidate = input.codeInput
      .distinctUntilChanged()
      .filter { $0.count == 6 }
      .withLatestFrom(timestampModel) { code, authNumber in
        guard authNumber.isAvailableCode() else {
          return false
        }
        return code == String(authNumber.authCode)
      }

    let checkUserExisted = isValidate
      .filter { $0 }
      .asObservable()
      .withUnretained(self)
      .flatMap { owner, _ in
        owner.useCase.checkUserExists(phoneNumber: owner.phoneNumber)
          .asObservable()
          .catch { error in
            errorTracker.onNext(error)
            return .empty()
          }
      }
      .asSignal(onErrorSignalWith: .empty())

    let needSignUp = Signal.zip(input.finishAnimationTrigger, checkUserExisted) { $1 }

    needSignUp.filter { $0.isSignUp == true }
      .asObservable()
      .withUnretained(self)
      .flatMapLatest { owner, signUpRes in
        owner.useCase.savePhoneNumber(owner.phoneNumber)
        return owner.useCase.login()
          .asObservable()
          .catch { error in
            errorTracker.onNext(error)
            return .empty()
          }
      }
      .asObservable()
      .observe(on: MainScheduler.asyncInstance)
      .subscribe(with: self) { owner, _ in
        owner.releaseTimer()
        owner.delegate?.didAuthComplete(option: .signIn)
      }.disposed(by: disposeBag)

    needSignUp
      .asObservable()
      .filter { $0.isSignUp == false }
      .observe(on: MainScheduler.asyncInstance)
      .subscribe(with: self, onNext: { owner, _ in
        owner.releaseTimer()
        owner.delegate?.didAuthComplete(option: .signUp(phoneNumber: owner.phoneNumber))
      }).disposed(by: disposeBag)

    let timestamp =
      tickTrigger
      .withLatestFrom(timestampModel) { $1.timeString }
      .asDriverOnErrorJustEmpty()

    return Output(
      description: description,
      error: errorTracker.asDriver(onErrorDriveWith: .empty()),
      certificateSuccess: isValidate.filter { $0 },
      certificateFailuer: isValidate.filter { !$0},
      timestamp: timestamp
    )
  }

  private func startTimer(timeDuration: Int) {
    let timer = Observable<Int>.timer(.seconds(0), period: .seconds(1), scheduler: MainScheduler.instance)
      .take(timeDuration + 1)
      .debug("tick")

    self.timerDisposable = timer
      .mapToVoid()
      .asSignal(onErrorSignalWith: .empty())
      .emit(to: tickTrigger)
  }

  private func releaseTimer() {
    self.timerDisposable?.dispose()
    self.timerDisposable = nil
  }
}
