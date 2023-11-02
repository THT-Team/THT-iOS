//
//  NicknameInputViewModel.swift
//  Falling
//
//  Created by Hoo's MacBookPro on 10/22/23.
//

import Foundation

import RxSwift
import RxCocoa

final class NicknameInputViewModel: ViewModelType {
	// FIXME: subject 이름 변경
	private let subject: PublishSubject<Void>
	let progressSubject: PublishSubject<UserInformationMainViewModel.UserInformationStep>
	
	init(
		subject: PublishSubject<Void>,
		progressSubject: PublishSubject<UserInformationMainViewModel.UserInformationStep>
	) {
		self.subject = subject
		self.progressSubject = progressSubject
	}
	
	private let disposeBag = DisposeBag()
	
	struct Input {
		let viewWillAppear: Driver<Void>
		let topBackBtnTapped: Driver<Void>
		let nicknameText: Driver<String>
		let clearBtnTapped: Driver<Void>
		let nextBtnTapped: Driver<Void>
	}
	
	struct Output {
		let nicknameText: Driver<String>
		let nicknameCntLblText: Driver<String>
		let enabledStatus: Driver<Bool>
		let navigateTrigger: Driver<Void>
	}
	
	func transform(input: Input) -> Output {
		input.viewWillAppear
			.map { _ in return UserInformationMainViewModel.UserInformationStep.nickname }
			.drive(with: self, onNext: { vm, step in
				vm.progressSubject.onNext(step)
			})
			.disposed(by: disposeBag)
		
		let nicknameText = input.nicknameText
			.map { String($0.prefix(12)) }
		
		let nicknameCntLblText = nicknameText
			.map { $0.count }
			.filter { $0 <= 12 }
			.map { "(\($0)/12)" }
		
		let enableStatus = nicknameText
			.map { $0.count > 0 }
		
		let outputText = Driver.merge(nicknameText, input.clearBtnTapped.map { "" })
		
		let navigateTrigger = input.nextBtnTapped
			.withLatestFrom(nicknameText) { _, nickname in
				print(nickname)
			}
			
		return Output(
			nicknameText: outputText,
			nicknameCntLblText: nicknameCntLblText,
			enabledStatus: enableStatus,
			navigateTrigger: navigateTrigger
		)
	}
}
