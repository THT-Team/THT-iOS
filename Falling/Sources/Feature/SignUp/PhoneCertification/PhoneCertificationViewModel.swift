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
		
		init(authCode: Int) {
			self.authCode = authCode
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
	
	private var authNumber: AuthCodeWithTimeStamp = AuthCodeWithTimeStamp(authCode: 0)
	private var timerRealy = BehaviorRelay(value: 0)
	private var viewType: ViewType = .phoneNumber
	private let navigator: SignUpNavigator
	
	init(navigator: SignUpNavigator) {
		self.navigator = navigator
	}
	
	func transform(input: Input) -> Output {
		
		let error = PublishRelay<Void>()

		let viewInit = input.viewWillAppear
			.map { ViewType.phoneNumber }
			.asDriver()
		
		let validate = input.phoneNum
			.map { $0.phoneNumValidation() }
			
		let phoneNum = input.phoneNum
			
		let clearButtonTapped = input.clearBtn
			.map { "" }.asDriver()
		
		let verifyButtonTapped = input.verifyBtn
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
			.withUnretained(self)
			.map { vm, res in
				vm.authNumber = AuthCodeWithTimeStamp(authCode: res.authNumber)
				vm.viewType = .authCode
				return Void()
			}
			.map({ _ in ViewType.authCode })
			.asDriver(onErrorJustReturn: .authCode)
		
		let viewStatus = Driver.merge(viewInit, verifyButtonTapped)
		
		let inputtedCode = input.codeInput
			.distinctUntilChanged()
			.filter { $0.count == 6 }
			.asObservable()
			.withUnretained(self)
			.map { vm, inputtedCode in
				guard vm.isAvailableCode(vm.authNumber.timeStamp) else { return false }
				return "\(vm.authNumber.authCode)" == inputtedCode
			}
			.debug()
			.asDriver(onErrorJustReturn: false)
		
		let timer = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
			.withUnretained(self)
			.filter { vm, _ in vm.viewType == .authCode }
			.debug()
			.filter { vm, _ in vm.isAvailableCode(vm.authNumber.timeStamp) }
			.take(until: inputtedCode.filter{ $0 == true }.asObservable())
			.share()
			
		let timeLabelStr = timer
			.map { vm, _ in
				return vm.getTimeStr(vm.authNumber.timeStamp)
			}
			.asDriver(onErrorJustReturn: "")
		
		let timerLabelColor = timer
			.map { vm, _ in
				if vm.isAvailableCode(vm.authNumber.timeStamp) {
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

extension PhoneCertificationViewModel {
	func isAvailableCode(_ timeStamp: Date) -> Bool {
		let timeInterval = timeStamp.timeIntervalSinceNow
		let sec = Int(timeInterval)
		return abs(sec) <= 180
	}
	
	func getTimeStr(_ timeStamp: Date) -> String {
		let timeInterval = timeStamp.timeIntervalSinceNow
		let min = abs(Int(timeInterval.truncatingRemainder(dividingBy: 3600)) / 60)
		let sec = abs(Int(timeInterval.truncatingRemainder(dividingBy: 60)))
		
		if sec < 10 {
			return "0\(min):0\(sec)"
		} else {
			return "0\(min):\(sec)"
		}
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
