//
//  PhoneCertificationViewModel.swift
//  Falling
//
//  Created by Hoo's MacBookPro on 2023/08/03.
//

import Foundation

import RxSwift
import RxCocoa
import RxRelay

final class PhoneCertificationViewModel: ViewModelType {
	
	var disposeBag = DisposeBag()
	
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
		let timeLabelTextColor: Driver<FallingColors>
	}

	private let navigator: SignUpNavigator
	
	init(navigator: SignUpNavigator) {
		self.navigator = navigator
	}
	
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
			.flatMap { vm, phoneNum in
//				AuthAPI.sendPhoneValidationCode(phoneNumber: phoneNum)
//					.asObservable()
//					.catch { _ in
//						error.accept(Void())
//						return .empty()
//					}
				vm.testApi(pNum: phoneNum).asObservable()
					.catch({ _ in
						error.accept(Void())
						return .empty()
					})
      }.asDriver(onErrorDriveWith: Driver<PhoneValidationResponse>.empty())

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
          return FallingAsset.Color.neutral50
        } else {
          return FallingAsset.Color.error
        }
      }
			.asDriver(onErrorJustReturn: FallingAsset.Color.neutral50)
		
		input.finishAnimationTrigger
			.debug()
			.asDriver()
			.drive(navigator.rx.toPhoneValidationView)
			.disposed(by: disposeBag)
			
		return Output(
			phoneNum: phoneNum,
		  validate: validate,
			error: error,
			clearButtonTapped: clearButtonTapped,
			viewStatus: viewStatus,
			certificateSuccess: inputtedCode.filter { $0 == true },
			certificateFailuer: inputtedCode.filter { $0 == false },
			timeStampLabel: timeLabelStr,
			timeLabelTextColor: timerLabelColor
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
}
