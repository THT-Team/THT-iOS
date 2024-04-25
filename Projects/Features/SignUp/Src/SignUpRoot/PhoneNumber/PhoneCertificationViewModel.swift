//
//  PhoneCertificationViewModel.swift
//  DSKit
//
//  Created by Hoo's MacBookPro on 2023/08/03.
//

import Foundation

import SignUpInterface
import DSKit

final class PhoneCertificationViewModel: ViewModelType {

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
    let navigatorDisposble: Driver<Void>
  }

  weak var delegate: SignUpCoordinatingActionDelegate?

  func transform(input: Input) -> Output {

    let error = PublishRelay<Void>()

    let validate = input.phoneNum
      .map { $0.phoneNumValidation() }

    let phoneNum = input.phoneNum

    let clearButtonTapped = input.clearBtn
      .map { "" }.asDriver()

    let verifyButtonTapped = input.verifyBtn
      .throttle(.milliseconds(1500), latest: false)
      .asObservable()
      .withUnretained(self)
      .flatMapLatest { owner, phoneNum in
        owner.testApi(pNum: phoneNum)
      }.asDriver(onErrorDriveWith: .empty())

    let authNumber = verifyButtonTapped
      .map { AuthCodeWithTimeStamp(authCode: $0.authNumber) }

    let viewStatus = authNumber.map { _ in ViewType.authCode }
      .startWith(.phoneNumber)

    let inputtedCode = input.codeInput
      .distinctUntilChanged()
      .filter { $0.count == 6 }
      .withLatestFrom(authNumber) { inputCode, authNumber -> Bool in
        guard authNumber.isAvailableCode() else {
          return false
        }
        return inputCode == "\(authNumber.authCode)"
      }
      .debug()
      .asDriver(onErrorJustReturn: false)

    let timer = authNumber
      .flatMap { authNumber in
        return Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
          .filter { _ in authNumber.isAvailableCode() }
          .take(until: inputtedCode.filter{ $0 == true }
            .asObservable()
          )
          .share()
          .asDriver(onErrorDriveWith: Driver<Int>.empty())
      }

    let timeLabelStr = timer
      .withLatestFrom(authNumber) { _, authNumber in
        authNumber.timeString
      }
      .debug("timer")
      .asDriver(onErrorJustReturn: "")

    let timerLabelColor = timer
      .withLatestFrom(authNumber) { _, authNumber in
        if authNumber.isAvailableCode() {
          return DSKitAsset.Color.neutral50
        } else {
          return DSKitAsset.Color.error
        }
      }
      .asDriver(onErrorJustReturn: DSKitAsset.Color.neutral50)

    let finishAuth = input.finishAnimationTrigger
      .do(onNext: { [weak self] _ in
        self?.delegate?.invoke(.nextAtPhoneNumber)
      })

    return Output(
      phoneNum: phoneNum,
      validate: validate,
      error: error,
      clearButtonTapped: clearButtonTapped,
      viewStatus: viewStatus,
      certificateSuccess: inputtedCode.filter { $0 == true },
      certificateFailuer: inputtedCode.filter { $0 == false },
      timeStampLabel: timeLabelStr,
      timeLabelTextColor: timerLabelColor,
      navigatorDisposble: finishAuth
    )
  }
}

// MARK: Test Code
extension PhoneCertificationViewModel {
  func testApi(pNum: String) -> Observable<PhoneValidationResponse> {
    return Single<PhoneValidationResponse>
      .just(PhoneValidationResponse(phoneNumber: pNum, authNumber: 123456))
      .asObservable()
  }

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
