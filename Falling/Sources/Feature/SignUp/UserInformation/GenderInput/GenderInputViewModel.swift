//
//  GenderInputViewModel.swift
//  Falling
//
//  Created by Hoo's MacBookPro on 10/29/23.
//

import Foundation

import RxSwift
import RxCocoa

final class GenderInputViewModel: ViewModelType {
	private let progressSubject:  PublishSubject<UserInformationMainViewModel.UserInformationStep>
	
	init(progressSubject: PublishSubject<UserInformationMainViewModel.UserInformationStep>) {
		self.progressSubject = progressSubject
	}
	private let disposeBag = DisposeBag()
	
	struct Input {
		let viewWillAppear: Driver<Void>
	}
	
	struct Output {
		
	}
	
	func transform(input: Input) -> Output {
		input.viewWillAppear
			.map { _ -> UserInformationMainViewModel.UserInformationStep in
				return .userGender
			}
			.drive(with: self, onNext: { vm, step in
				vm.progressSubject.onNext(step)
			})
			.disposed(by: disposeBag)
		
		return Output()
	}
}
