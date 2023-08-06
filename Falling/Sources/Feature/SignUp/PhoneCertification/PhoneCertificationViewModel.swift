//
//  PhoneCertificationViewModel.swift
//  Falling
//
//  Created by Hoo's MacBookPro on 2023/08/03.
//

import Foundation

import RxSwift
import RxCocoa

final class PhoneCertificationViewModel: ViewModelType {
	
	var disposeBag = DisposeBag()
	
	struct Input {
		let phoneNum: Observable<String>
		let clearBtn: Driver<Void>
		let verifyBtn: Driver<Void>
	}
	
	struct Output {
		let phoneNum: Observable<String>
		let validate: Observable<Bool>
	}
	
	private let navigator: SignUpNavigator
	
	init(navigator: SignUpNavigator) {
		self.navigator = navigator
	}
	
	private let phoneNum = BehaviorSubject(value: "")
	private let validate = BehaviorSubject(value: false)
	
	func transform(input: Input) -> Output {
		input.phoneNum
			.map { [weak self] phoneNum -> String in
				guard let self else { return phoneNum }
				if phoneNum.isEmpty { return phoneNum }
				
				if phoneNum.phoneNumValidation() {
					self.validate.onNext(true)
				} else {
					self.validate.onNext(false)
				}
				
				return phoneNum
			}
			.bind(to: phoneNum)
			.disposed(by: disposeBag)
		
		input.clearBtn
			.drive(onNext: { [weak self] in
				guard let self else { return }
				self.phoneNum.onNext("")
			})
			.disposed(by: disposeBag)
		
		input.verifyBtn
			.throttle(.milliseconds(1500))
			.asObservable()
			.compactMap { [weak self] in
				try self?.phoneNum.value()
			}
			.flatMap { phoneNum -> Single<PhoneNumberValidationCodeResponse> in
//				AuthAPI.sendPhoneValidationCode(phoneNumber: phoneNum)
				self.testApi(pNum: phoneNum)
			}
			.subscribe { [weak self] in
				guard let self else { return }
				switch $0 {
				case .next(let res):
					print(res)
					self.navigator.toPhoneValidationView(validationCode: res.authNumber)
				case let .error(err):
					print(err)
				case .completed:
					print("complete")
				}
			}
			.disposed(by: disposeBag)
		
		return Output(
			phoneNum: phoneNum,
			validate: validate
		)
	}
}

// MARK: Test Code
extension PhoneCertificationViewModel {
	func testApi(pNum: String) -> Single<PhoneNumberValidationCodeResponse> {
		return Single<PhoneNumberValidationCodeResponse>.just(
			PhoneNumberValidationCodeResponse(phoneNumber: pNum, authNumber: 123456)
		)
	}
}
