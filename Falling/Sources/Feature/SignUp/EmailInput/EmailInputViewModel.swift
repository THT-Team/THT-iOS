//
//  EmailInputViewModel.swift
//  Falling
//
//  Created by Hoo's MacBookPro on 2023/08/06.
//

import Foundation

import RxSwift
import RxCocoa

final class EmailInputViewModel: ViewModelType {
	enum EmailTextState {
		case empty
		case valid
		case invalid
	}
	
	private let navigator: SignUpNavigator
	
	init(navigator: SignUpNavigator) {
		self.navigator = navigator
	}
	
	private let disposeBag = DisposeBag()
	
	struct Input {
		let emailText: Driver<String>
		let clearBtnTapped: Driver<Void>
		let nextBtnTap: Driver<Void>
		let naverBtnTapped: Driver<Void>
		let kakaoBtnTapped: Driver<Void>
		let gmailBtnTapped: Driver<Void>
	}
	
	struct Output {
		let buttonState: Driver<Bool>
		let warningLblState: Driver<Bool>
		let emailTextStatus: Driver<EmailTextState>
		let buttonTappedResult: Disposable
		let emailText: Driver<String>
	}
	
	func transform(input: Input) -> Output {
		let textFieldTextRealy = BehaviorRelay<String>(value: "")
		
		input.emailText
			.drive(textFieldTextRealy)
			.disposed(by: disposeBag)
		
		input.clearBtnTapped
			.map { "" }
			.drive(textFieldTextRealy)
			.disposed(by: disposeBag)
		
		let emailValidate = textFieldTextRealy.asDriver()
			.map {
				if $0.isEmpty {
					return EmailTextState.empty
				} else {
					if $0.emailValidation() {
						return EmailTextState.valid
					} else {
						return EmailTextState.invalid
					}
				}
			}
			.asObservable()
		
		let buttonState = emailValidate
			.map {
				switch $0 {
				case .empty, .invalid:
					return false
				case .valid:
					return true
				}
			}
			.asDriver(onErrorJustReturn: false)
		
		let warningLblState = emailValidate
			.map {
				switch $0 {
				case .empty, .valid:
					return true
				case .invalid:
					return false
				}
			}
			.asDriver(onErrorJustReturn: false)
		
		let emailTextStatus = emailValidate.asDriver(onErrorJustReturn: .empty)
		
		let buttonTappedResult = input.nextBtnTap
			.drive(onNext: { print("123") })
			
		let _ = Driver
			.merge([input.naverBtnTapped.map { "@naver.com" },
							input.gmailBtnTapped.map { "@gmail.com" },
							input.kakaoBtnTapped.map { "@kakao.com" }])
			.asDriver()
			.map { textFieldTextRealy.value + $0 }
			.drive(textFieldTextRealy)
			.disposed(by: disposeBag)
		
		return Output(
			buttonState: buttonState,
			warningLblState: warningLblState,
			emailTextStatus: emailTextStatus,
			buttonTappedResult: buttonTappedResult,
			emailText: textFieldTextRealy.asDriver()
		)
	}
}
