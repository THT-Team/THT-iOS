//
//  EmailDomainBtn.swift
//  Falling
//
//  Created by Hoo's MacBookPro on 2023/08/27.
//

import UIKit

import RxSwift

enum ServiceEmailDomain {
	case naver
	case gmail
	case kakao
	
	var domainStr: String {
		switch self {
		case .naver:
			return "@naver.com"
		case .gmail:
			return "@gmail.com"
		case .kakao:
			return "@kakao.com"
		}
	}
	
}

final class EmailDomainBtn: UIButton {
	let emailDomain: ServiceEmailDomain
	
	init(emailDomain: ServiceEmailDomain) {
		self.emailDomain = emailDomain
		super.init(frame: .zero)
		setTitle(emailDomain.domainStr, for: .normal)
	}
	
	func test() -> Observable<String> {
		return .just(emailDomain.domainStr)
	}
	
	func changeBtnTitle(userInput: String) {
		var input: String = ""
		
		if let index = userInput.firstIndex(of: "@") {
			input = String(userInput[..<index])
		} else {
			input = userInput
		}
		
		let title = input + emailDomain.domainStr
		setTitle(title, for: .normal)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}


extension Reactive where Base: EmailDomainBtn {
	var setTitle: Binder<String> {
		return Binder(base.self) { btn, userInput in
			btn.changeBtnTitle(userInput: userInput)
		}
	}
}
