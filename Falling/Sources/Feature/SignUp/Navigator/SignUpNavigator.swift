//
//  SignUpNavigator.swift
//  Falling
//
//  Created by Hoo's MacBookPro on 2023/07/29.
//

import UIKit
import RxSwift

final class SignUpNavigator {
	let controller: UINavigationController
	
	init(controller: UINavigationController) {
		self.controller = controller
	}
	
	func toRootView() {
		let viewModel = SignUpRootViewModel(navigator: self)
		let rootView = SignUpRootViewController(viewModel: viewModel)
		controller.pushViewController(rootView, animated: true)
	}
	
	func toPhoenCertifiationView() {
		let viewModel = PhoneCertificationViewModel(navigator: self)
		let viewcontroller = PhoneCertificationViewController(viewModel: viewModel)
		
		controller.pushViewController(viewcontroller, animated: true)
	}
	
	func toPhoneValidationView() {
		let viewModel = PhoneValidationViewModel()
		let viewController = PhoneValidationViewController(viewModel: viewModel)
		
		controller.pushViewController(viewController, animated: true)
	}
}

extension SignUpNavigator: ReactiveCompatible { }

extension Reactive where Base: SignUpNavigator {
	var toPhoneValidationView: Binder<Void> {
		return Binder(base.self) { navigator, code in
			navigator.toPhoneValidationView()
		}
	}
}
