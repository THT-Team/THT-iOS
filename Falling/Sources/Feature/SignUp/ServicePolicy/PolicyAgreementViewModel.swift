//
//  PolicyAgreementViewModel.swift
//  Falling
//
//  Created by Hoo's MacBookPro on 2023/10/02.
//

import Foundation

import RxSwift
import RxCocoa

final class PolicyAgreementViewModel: ViewModelType {
	private let navigator: SignUpNavigator
	
	init(navigator: SignUpNavigator) {
		self.navigator = navigator
	}
	
	private let disposeBag = DisposeBag()
	
	struct Input {
		let agreeAllBtn: Driver<Void>
		let tosAgreeBtn: Driver<Void>
		let showTosDetailBtn: Driver<Void>
		let privacyAgreeBtn: Driver<Void>
		let showPrivacyDetailBtn: Driver<Void>
		let locationServiceAgreeBtn: Driver<Void>
		let showLocationServiceDetailBtn: Driver<Void>
		let marketingServiceAgreeBtn: Driver<Void>
		let nextBtn: Driver<Void>
	}
	
	struct Output {
		let agreeAllRowImage: Driver<FallingImages>
		let tosAgreeRowImage: Driver<FallingImages>
		let privacyAgreeRowImage: Driver<FallingImages>
		let locationServiceAgreeRowImage: Driver<FallingImages>
		let marketingServiceRowImage: Driver<FallingImages>
		let nextBtnStatus: Driver<Bool>
	}
	
	func transform(input: Input) -> Output {
		let agreeAllRealy = BehaviorRelay<Bool>(value: false)
		let tosAgreeStatus = BehaviorRelay(value: false)
		let privacyAgreeStatus = BehaviorRelay(value: false)
		let locationServiceStatus = BehaviorRelay(value: false)
		let marketingServiceStatus = BehaviorRelay(value: false)
		
		input.agreeAllBtn
			.map { !agreeAllRealy.value }
			.drive(agreeAllRealy, tosAgreeStatus, privacyAgreeStatus, locationServiceStatus, marketingServiceStatus)
			.disposed(by: disposeBag)
		
		input.tosAgreeBtn
			.map { !tosAgreeStatus.value }
			.drive(tosAgreeStatus)
			.disposed(by: disposeBag)
		
		input.privacyAgreeBtn
			.map { !privacyAgreeStatus.value }
			.drive(privacyAgreeStatus)
			.disposed(by: disposeBag)
		
		input.locationServiceAgreeBtn
			.map { !locationServiceStatus.value }
			.drive(locationServiceStatus)
			.disposed(by: disposeBag)
		
		input.marketingServiceAgreeBtn
			.map { !marketingServiceStatus.value }
			.drive(marketingServiceStatus)
			.disposed(by: disposeBag)
	
		let agreeAllRowImage = agreeAllRealy
			.map { $0 ? FallingAsset.Image.checkCirSelect : FallingAsset.Image.checkCir }
			.asDriver(onErrorJustReturn: FallingAsset.Image.checkCir)
		
		let tosAgreeRowImage = tosAgreeStatus
			.map { $0 ? FallingAsset.Image.checkSelect : FallingAsset.Image.check }
			.asDriver(onErrorJustReturn: FallingAsset.Image.check)
		
		let privacyAgreeRowImage = privacyAgreeStatus
			.map { $0 ? FallingAsset.Image.checkSelect : FallingAsset.Image.check }
			.asDriver(onErrorJustReturn: FallingAsset.Image.check)
		
		let locationServiceAgreeRowImage = locationServiceStatus
			.map { $0 ? FallingAsset.Image.checkSelect : FallingAsset.Image.check }
			.asDriver(onErrorJustReturn: FallingAsset.Image.check)
		
		let marketingServiceRowImage = marketingServiceStatus
			.map { $0 ? FallingAsset.Image.checkSelect : FallingAsset.Image.check }
			.asDriver(onErrorJustReturn: FallingAsset.Image.check)
		
		let nextBtnStatus = Observable
			.combineLatest(tosAgreeStatus, privacyAgreeStatus, locationServiceStatus) { $0 && $1 && $2 }
			.map { $0 }
		
		return Output(
			agreeAllRowImage: agreeAllRowImage,
			tosAgreeRowImage: tosAgreeRowImage,
			privacyAgreeRowImage: privacyAgreeRowImage,
			locationServiceAgreeRowImage: locationServiceAgreeRowImage,
			marketingServiceRowImage: marketingServiceRowImage,
			nextBtnStatus: nextBtnStatus.asDriver(onErrorJustReturn: false)
		)
	}
}
