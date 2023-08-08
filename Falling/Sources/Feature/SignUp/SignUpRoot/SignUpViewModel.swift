//
//  SignUpViewModel.swift
//  Falling
//
//  Created by Hoo's MacBookPro on 2023/07/22.
//

import Foundation

import RxSwift
import RxCocoa

final class SignUpRootViewModel: ViewModelType {
	struct Input {
		let phoneBtn: Driver<Void>
		let kakaoBtn: Driver<Void>
		let googleBtn: Driver<Void>
		let naverBtn: Driver<Void>
	}
	
	struct Output {
		
	}
	
	private let navigator: SignUpNavigator
	
	init(navigator: SignUpNavigator) {
		self.navigator = navigator
	}
	
	var disposeBag: DisposeBag = DisposeBag()
	
	func transform(input: Input) -> Output {
		input.phoneBtn
			.drive(onNext: { [weak self] in
				guard let self else { return }
				navigator.toPhoenCertifiationView()
			})
			.disposed(by: disposeBag)
		
		input.kakaoBtn
			.drive(onNext: { [weak self] in
				guard let self else { return }
				print("kakao button")
			})
			.disposed(by: disposeBag)
		
		input.naverBtn
			.drive(onNext: { [weak self] in
				guard let self else { return }
				print("naver button")
			})
			.disposed(by: disposeBag)
		
		input.googleBtn
			.drive(onNext: { [weak self] in
				guard let self else { return }
				print("google button")
			})
			.disposed(by: disposeBag)
			
		return Output()
	}
}
