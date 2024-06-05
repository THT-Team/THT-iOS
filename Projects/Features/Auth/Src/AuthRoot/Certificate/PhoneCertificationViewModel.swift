//
//  PhoneCertificationViewModel.swift
//  DSKit
//
//  Created by Hoo's MacBookPro on 2023/08/03.
//

import Foundation

import AuthInterface
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
    let error: Driver<Error>
    let clearButtonTapped: Driver<String>
    let viewStatus: Driver<ViewType>
    let certificateSuccess: Driver<Bool>
    let certificateFailuer: Driver<Bool>
    let timeStampLabel: Driver<String>
    let timeLabelTextColor: Driver<DSKitColors>
  }

  weak var delegate: AuthCoordinatingActionDelegate?
  private let useCase: AuthUseCaseInterface
  private let userInfoUseCase: UserInfoUseCaseInterface

  private var disposeBag = DisposeBag()

  init(useCase: AuthUseCaseInterface, userInfoUseCase: UserInfoUseCaseInterface) {
    self.useCase = useCase
    self.userInfoUseCase = userInfoUseCase
  }

  func transform(input: Input) -> Output {

    let errorTracker = PublishRelay<Error>()
    
    let phoneNum = input.phoneNum
      .debounce(.milliseconds(300))

    let validate = phoneNum
      .map { $0.phoneNumValidation() }

    let clearButtonTapped = input.clearBtn
      .map { "" }.asDriver()

    let response = input.verifyBtn
      .throttle(.milliseconds(500), latest: false)
      .asObservable()
      .withUnretained(self)
      .flatMapLatest { owner, phoneNum in
        owner.useCase.certificate(phoneNumber: phoneNum)
          .catch { certificateError in
            errorTracker.accept(certificateError)
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
          .asObservable()
          .catch { networkError in
            errorTracker.accept(networkError)
            return .empty()
          }
      }.asDriverOnErrorJustEmpty()

    let userInfo = certificateSuccess
      .withLatestFrom(phoneNum)
      .asObservable()
      .withUnretained(self)
      .flatMapLatest({ owner, phoneNum in
        owner.userInfoUseCase.fetchUserInfo()
          .catchAndReturn(UserInfo(phoneNumber: phoneNum))
      })
      .asDriverOnErrorJustEmpty()

    checkUserExists
      .withLatestFrom(Driver<UserInfo>.combineLatest(userInfo, phoneNum) { userinfo, phoneNum in
        var mutable = userinfo
        mutable.phoneNumber = phoneNum
        return mutable
      })
      .drive(with: self) { owner, userinfo in
        owner.userInfoUseCase.updateUserInfo(userInfo: userinfo)
      }.disposed(by: disposeBag)


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

    isSignUp.filter { $0.isSignUp == true }
      .withLatestFrom(phoneNum) { _, phoneNum in phoneNum }
      .drive(with: self) { owner, phoneNum in
        owner.userInfoUseCase.savePhoneNumber(phoneNum)
      }
      .disposed(by: disposeBag)

    isSignUp.filter { $0.isSignUp == true }
      .withLatestFrom(phoneNum) { _, phoneNum in phoneNum }
      .asObservable()
      .withUnretained(self)
      .flatMapLatest { owner, phoneNum in
        owner.useCase.login(phoneNumber: phoneNum, deviceKey: "device_key")
          .asObservable()
          .catch { error in
            errorTracker.accept(error)
            return .empty()
          }
      }
      .asDriverOnErrorJustEmpty()
      .drive(with: self) { owner, _ in
        owner.delegate?.invoke(.toMain)
      }.disposed(by: disposeBag)

    isSignUp.filter { $0.isSignUp == false }
      .withLatestFrom(phoneNum)
      .drive(with: self, onNext: { owner, phoneNum in
        owner.delegate?.invoke(.toSignUp(phoneNumber: phoneNum))
      })
      .disposed(by: disposeBag)

    return Output(
      phoneNum: phoneNum,
      validate: validate,
      error: errorTracker.asDriverOnErrorJustEmpty(),
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
