//
//  UserInformationMainViewModel.swift
//  Falling
//
//  Created by Hoo's MacBookPro on 10/19/23.
//

import Foundation

import RxSwift
import RxCocoa

final class UserInformationMainViewModel: ViewModelType {
	enum UserInformationStep {
		case nickname
		case userGender
		case birthDay
		case favorGender
	}
	
	private let navigator: SignUpNavigator
	
	init(navigator: SignUpNavigator) {
		self.navigator = navigator
	}
	let disposeBag = DisposeBag()
	
	let popBackSubject: PublishSubject<Void> = PublishSubject()
	let progressSubject = PublishSubject<UserInformationStep>()

	
	struct Input {
		
	}
	
	struct Output {
		let progressStep: Driver<Double>
		let disposable: Disposable
	}
	
	func transform(input: Input) -> Output {
		let progressStepDouble = progressSubject
			.map { step -> Double in
				switch step {
				case .nickname:
					return 1
				case .userGender:
					return 2
				case .birthDay:
					return 3
				case .favorGender:
					return 4
				}
			}
			.asDriverOnErrorJustEmpty()
		
		let disposable = popBackSubject
			.bind(to: navigator.rx.popBack)
			
		return Output(
			progressStep: progressStepDouble,
			disposable: disposable
		)
	}
}
