//
//  PhoneNumberAuthVM.swift
//  Auth
//
//  Created by Kanghos on 12/16/24.
//

import Foundation

import DSKit
import AuthInterface
import Domain

public final class PhoneNumberAuthVM: PhoneNumberAuthViewModelType {
  public var onSuccess: ((String) -> Void)?

  private let phoneNumber: String
  private let useCase: AuthUseCaseInterface
  private var disposeBag = DisposeBag()

  public struct Input {
    public let viewWillAppear: Signal<Void>
    public let codeInput: Driver<String>
    public let finishAnimationTrigger: Signal<Void>
    public let resendBtnTap: Signal<Void>
  }

  public struct Output {
    public let description: Driver<String>
    public let error: Driver<Error>
    public let certificateSuccess: Driver<Bool>
    public let certificateFailuer: Driver<Bool>
    public let timestamp: Driver<String>
  }

  public init(phoneNumber: String, useCase: AuthUseCaseInterface) {
    self.phoneNumber = phoneNumber
    self.useCase = useCase
  }

  deinit {
    TFLogger.cycle(name: self)
    releaseTimer()
  }

  var timerDisposable: Disposable?

  let tickTrigger = PublishSubject<Void>()

  public func transform(input: Input) -> Output {
    let errorTracker = PublishSubject<Error>()

    let authNumber = Signal.merge(input.resendBtnTap, input.viewWillAppear)
      .do(onNext: { [weak self] in
        self?.startTimer()
      })
      .flatMapLatest { [weak self] _ -> Driver<Int> in
        guard let self else { return .empty() }

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
        timeDuration: 180)}

    let isValidate = input.codeInput
      .distinctUntilChanged()
      .filter { $0.count == 6 }
      .withLatestFrom(timestampModel) { code, authNumber in
        guard authNumber.isAvailableCode() else {
          return false
        }
        return code == String(authNumber.authCode)
      }

    let validatePass = isValidate
      .filter { $0 }
      .mapToVoid()
      .asSignal(onErrorSignalWith: .empty())

    let timestamp = tickTrigger
      .withLatestFrom(timestampModel) { $1.timeString }
      .asDriverOnErrorJustEmpty()

    Signal.zip(validatePass, input.finishAnimationTrigger)
      .emit(with: self, onNext: { owner, _ in
        owner.onSuccess?(owner.phoneNumber)
      })
      .disposed(by: disposeBag)

    return Output(
      description: .just(phoneNumber + "으로\n전송된 코드를 입력해주세요."),
      error: errorTracker.asDriver(onErrorDriveWith: .empty()),
      certificateSuccess: isValidate.filter { $0 },
      certificateFailuer: isValidate.filter { !$0},
      timestamp: timestamp
    )
  }
}

extension PhoneNumberAuthVM {
  private func startTimer() {

    self.releaseTimer()

    let timeDuration = 180
    self.timerDisposable = Observable<Int>
      .timer(.seconds(0), period: .seconds(1), scheduler: MainScheduler.instance)
      .take(timeDuration + 1)
      .debug("tick")
      .mapToVoid()
      .bind(to: tickTrigger)
  }

  private func releaseTimer() {
    self.timerDisposable?.dispose()
    self.timerDisposable = nil
  }
}
