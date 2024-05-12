//
//  PhoneCertificationViewModel.swift
//  DSKit
//
//  Created by Hoo's MacBookPro on 2023/08/03.
//

import Foundation

import AuthInterface
import DSKit

final class PhoneCertificationViewModel: ViewModelType {
  private let useCase: SignUpUseCaseInterface

  struct Input {
    let viewWillAppear: Driver<Void>
    let phoneNum: Driver<String>
    let clearBtn: Driver<Void>
    let verifyBtn: Driver<String>
    let codeInput: Driver<String>
    let finishAnimationTrigger: Driver<Void>
  }

  struct Output {
    let phoneNum: Driver<String>
    let validate: Driver<Bool>
    let error: PublishRelay<Void>
    let clearButtonTapped: Driver<String>
    let viewStatus: Driver<ViewType>
    let certificateSuccess: Driver<Bool>
    let certificateFailuer: Driver<Bool>
    let timeStampLabel: Driver<String>
    let timeLabelTextColor: Driver<DSKitColors>
  }
  
  init(useCase: SignUpUseCaseInterface) {
    self.useCase = useCase
  }

  weak var delegate: AuthCoordinatingActionDelegate?
  private let useCase: AuthUseCaseInterface

  private var disposeBag = DisposeBag()

  init(useCase: AuthUseCaseInterface) {
    self.useCase = useCase
  }

  func transform(input: Input) -> Output {

    let error = PublishRelay<Void>()

    let validate = input.phoneNum
      .map { $0.phoneNumValidation() }

    let phoneNum = input.phoneNum

    let clearButtonTapped = input.clearBtn
      .map { "" }.asDriver()

    let response = input.verifyBtn
      .throttle(.milliseconds(1500), latest: false)
      .asObservable()
      .withUnretained(self)
      .flatMapLatest { owner, phoneNum in
        owner.useCase.certificate(phoneNumber: phoneNum)
          .catch { certificateError in
            error.accept(())
            return .error(certificateError)
          }
      }.asDriver(onErrorDriveWith: .empty())

    let authNumber = response
      .map { AuthCodeWithTimeStamp(authCode: $0) }

    let viewStatus = authNumber.map { _ in ViewType.authCode }
      .startWith(.phoneNumber)

    let certificateResult = input.codeInput
      .distinctUntilChanged()
      .filter { $0.count == 6 }
      .withLatestFrom(authNumber) { inputCode, authNumber -> Bool in
        guard authNumber.isAvailableCode() else {
          return false
        }
        return inputCode == "\(authNumber.authCode)"
      }
      .asDriver(onErrorJustReturn: false)

    let certificateSuccess = certificateResult.filter { $0 == true }

    let checkUserExists = certificateSuccess
      .withLatestFrom(phoneNum)
      .asObservable()
      .withUnretained(self)
      .flatMapLatest { owner, phoneNum in
        owner.useCase.checkUserExists(phoneNumber: phoneNum)
          .catch { networkError in
            error.accept(())
            return .error(networkError)
          }
      }.asDriverOnErrorJustEmpty()

    let timer = authNumber
      .flatMap { authNumber in
        return Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
          .filter { _ in authNumber.isAvailableCode() }
          .take(until: certificateResult.filter{ $0 == true }
            .asObservable()
          )
          .asDriver(onErrorDriveWith: Driver<Int>.empty())
      }

    let timeLabelStr = timer
      .withLatestFrom(authNumber) { _, authNumber in
        authNumber.timeString
      }

    let timerLabelColor = timer
      .withLatestFrom(authNumber) { _, authNumber in
        if authNumber.isAvailableCode() {
          return DSKitAsset.Color.neutral50
        } else {
          return DSKitAsset.Color.error
        }
      }

    let isSignUp = Driver.zip(input.finishAnimationTrigger, checkUserExists) { $1 }

    let newUser = isSignUp.filter { $0.isSignUp == false }

    isSignUp
      .filter { $0.isSignUp == true }
      .withLatestFrom(phoneNum)
      .flatMapLatest({ [unowned self] phoneNum in
        self.useCase.login(phoneNumber: phoneNum, deviceKey: "")
          .catch { loginError in
            error.accept(())
            return .error(loginError)
          }
          .asDriver(onErrorDriveWith: .empty())
      })
      .drive(with: self) { owner, _ in
        owner.delegate?.invoke(.toMain)
      }.disposed(by: disposeBag)

    newUser
      .withLatestFrom(phoneNum)
      .drive(with: self, onNext: { owner, phoneNum in
        owner.delegate?.invoke(.toSignUp(phoneNumber: phoneNum))
      })
      .disposed(by: disposeBag)

    return Output(
      phoneNum: phoneNum,
      validate: validate,
      error: error,
      clearButtonTapped: clearButtonTapped,
      viewStatus: viewStatus,
      certificateSuccess: certificateSuccess,
      certificateFailuer: certificateResult.filter { $0 == false },
      timeStampLabel: timeLabelStr,
      timeLabelTextColor: timerLabelColor
    )
  }
}

// MARK: Test Code
extension PhoneCertificationViewModel {

  enum ViewType {
    case phoneNumber
    case authCode
  }

  struct AuthCodeWithTimeStamp {
    let authCode: Int
    let timeStamp = Date.now
    var timeString: String {
      let timeInterval = timeStamp.timeIntervalSinceNow
      let min = abs(Int(timeInterval.truncatingRemainder(dividingBy: 3600)) / 60)
      let sec = abs(Int(timeInterval.truncatingRemainder(dividingBy: 60)))
      return String(format: "%02d:%02d", min, sec)
    }
    init(authCode: Int) {
      self.authCode = authCode
    }

    func isAvailableCode() -> Bool {
      let timeInterval = timeStamp.timeIntervalSinceNow
      let sec = Int(timeInterval)
      return abs(sec) <= 180
    }
  }
}
