//
//  PhoneValidationViewModel.swift
//  Falling
//
//  Created by Hoo's MacBookPro on 2023/08/06.
//

import Foundation

import RxSwift
import RxCocoa

final class PhoneValidationViewModel: ViewModelType {
	
	private let validationCode: Int
	
	init(
		validationCode: Int
	) {
		self.validationCode = validationCode
	}
	
	var disposeBag = DisposeBag()
	
	struct Input {
		
	}
	
	struct Output {
		let validationCode: Observable<String>
	}
	
	func transform(input: Input) -> Output {
		return Output(validationCode: Observable.just("\(validationCode)"))
	}
}
