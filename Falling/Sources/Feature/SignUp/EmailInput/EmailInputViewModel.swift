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
	
	
	init() { }
	
	var disposeBag = DisposeBag()
	
	struct Input {
		
	}
	
	struct Output {
		
	}
	
	func transform(input: Input) -> Output {
		return Output()
	}
}
