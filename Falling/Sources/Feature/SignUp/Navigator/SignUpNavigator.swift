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
	
	func toEmailInputView() {
		let viewModel = EmailInputViewModel(navigator: self)
		let viewController = EmailInputViewController(viewModel: viewModel)
		
		controller.pushViewController(viewController, animated: true)
	}
	
	func toPolicyAgreementView() {
		let viewModel = PolicyAgreementViewModel(navigator: self)
		let viewController = PolicyAgreementViewController(viewModel: viewModel)
		
		controller.pushViewController(viewController, animated: true)
	}
	
	func toUserInformationAcceptMainView() {
		let viewModel = UserInformationMainViewModel(navigator: self)
		let viewController = UserInformationMainViewController(viewModel: viewModel)
		
		controller.pushViewController(viewController, animated: true)
	}
	
	func popBackViewController() {
		controller.popViewController(animated: true)
	}
}

extension SignUpNavigator: ReactiveCompatible { }

extension Reactive where Base: SignUpNavigator {
	var toEmailInputView: Binder<Void> {
		return Binder(base.self) { navigator, code in
			navigator.toEmailInputView()
		}
	}
	
	var toPolicyAgreementView: Binder<Void> {
		return Binder(base.self) { navigator, code in
			navigator.toPolicyAgreementView()
		}
	}
	
	var toUserInformationMainView: Binder<Void> {
		return Binder(base.self) { navigator, code in
			navigator.toUserInformationAcceptMainView()
		}
	}
	
	var popBack: Binder<Void> {
		return Binder(base.self) { navigator, code in
			navigator.popBackViewController()
		}
	}
}
