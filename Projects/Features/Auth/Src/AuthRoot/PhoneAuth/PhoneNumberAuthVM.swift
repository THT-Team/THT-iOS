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
    public let trigger: Signal<Void>
    public let codeInput: Driver<String>
    public let finishAnimationTrigger: Signal<Void>
  }

  public struct Output {
    public let description: Observable<String>
    public let toast: Observable<String>
    public let isCertificated: Observable<Bool>
    public let timestamp: Observable<String>
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
    let duration: Int = 180
    let errorTracker = PublishSubject<Error>()

    let trigger = input.trigger
      .do(onNext:  { [weak self] in
        self?.releaseTimer()
        self?.startTimer(duration: duration)
      })

    let timeStamp = trigger.map { TimeStamp(timeDuration: duration) }
      .asObservable()

    let code = trigger
      .asObservable()
      .withUnretained(self)
      .flatMapLatest { owner, _ in
        owner.useCase.certificate(phoneNumber: owner.phoneNumber)
          .asObservable()
          .catch { errorTracker.onNext($0)
            owner.releaseTimer()
            return .empty()
          }
      }
      .map(String.init)

    let inputCode = input.codeInput
      .debounce(.milliseconds(300))
      .distinctUntilChanged()
      .filter { $0.count == 6 }
      .asObservable()

    let isValidate = Observable.combineLatest(inputCode, timeStamp, code) { input, time, code -> Bool in
      time.isAvailable ? input == code : false
    }

    input.finishAnimationTrigger
      .do(onNext: { [weak self] _ in
        self?.releaseTimer()
      })
      .emit(with: self, onNext: { owner, _ in
        owner.onSuccess?(owner.phoneNumber)
      })
      .disposed(by: disposeBag)

    return Output(
      description: .just(phoneNumber + "으로\n전송된 코드를 입력해주세요."),
      toast: errorTracker.map(\.localizedDescription),
      isCertificated: isValidate,
      timestamp: tickTrigger
        .withLatestFrom(timeStamp).map(\.timeString)
    )
  }
}

extension PhoneNumberAuthVM {
  private func startTimer(duration: Int) {
    self.timerDisposable = Observable<Int>
      .timer(.seconds(0), period: .seconds(1), scheduler: MainScheduler.instance)
      .take(duration + 1)
      .mapToVoid()
      .bind(to: tickTrigger)
  }

  private func releaseTimer() {
    self.timerDisposable?.dispose()
    self.timerDisposable = nil
  }
}
