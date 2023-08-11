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
	
	enum viewType {
		case phoneNumber
		case authCode
	}
	
	struct Input {
		let phoneNum: Driver<String>
		let clearBtn: Driver<Void>
		let verifyBtn: Driver<String>
	}
	
	struct Output {
		let phoneNum: Driver<String>
		let validate: Driver<Bool>
		let error: PublishRelay<Void>
		let clearButtonTapped: Driver<String>
		let viewStatus: Driver<viewType>
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
		
//		input.verifyBtn
//			.throttle(.milliseconds(1500), latest: false)
//			.asObservable()
//			.withUnretained(self)
//			.flatMap { vm, phoneNum -> Observable<PhoneValidationResponse> in
////				AuthAPI.sendPhoneValidationCode(phoneNumber: phoneNum)
////					.asObservable()
////					.catch { _ in
////						error.accept(Void())
////						return .empty()
////					}
//				vm.testApi(pNum: phoneNum).asObservable()
//					.catch({ _ in
//						error.accept(Void())
//						return .empty()
//					})
//			}
//			.map({ $0.authNumber })
//			.bind(to: navigator.rx.toPhoneValidationView)
//			.disposed(by: disposeBag)
		
	let viewStatus = input.verifyBtn
			.throttle(.milliseconds(1500), latest: false)
			.asObservable()
			.withUnretained(self)
			.flatMap { vm, phoneNum -> Observable<PhoneValidationResponse> in
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
			}
			.map({ _ in viewType.authCode })
			.asDriver(onErrorJustReturn: .authCode)
		
		return Output(
			phoneNum: phoneNum,
		  validate: validate,
			error: error,
			clearButtonTapped: clearButtonTapped,
			viewStatus: viewStatus
		)
	}
}

// MARK: Test Code
extension PhoneCertificationViewModel {
	func testApi(pNum: String) -> Observable<PhoneValidationResponse> {
		return Single<PhoneValidationResponse>
			.just(PhoneValidationResponse(phoneNumber: pNum, authNumber: 123456))
			.asObservable()
//		return Observable.create {
//			$0.onError(MyError.testError)
//
//			return Disposables.create()
//		}
	}
}

enum MyError: Error {
	case testError
}
