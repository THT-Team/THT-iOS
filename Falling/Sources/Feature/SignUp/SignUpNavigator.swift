//
//  SignUpNavigator.swift
//  Falling
//
//  Created by Hoo's MacBookPro on 2023/07/29.
//

import UIKit

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
}
