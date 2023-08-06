//
//  Application.swift
//  Falling
//
//  Created by Hoo's MacBookPro on 2023/07/29.
//

import UIKit

final class Application {
	static let shared = Application()
	
	func configurationMainInterface(window: UIWindow?) {
		let signUpController = UINavigationController()
		let signUpNavigator = SignUpNavigator(controller: signUpController)
		
		window?.rootViewController = signUpController
		signUpNavigator.toRootView()
	}
	
	private init() { }
}
