//
//  SceneDelegate.swift
//  App
//
//  Created by Hoo's MacBookPro on 12/3/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
	
	var window: UIWindow?
	
	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		guard let windowScene = (scene as? UIWindowScene) else { return }
		
		let window = UIWindow(windowScene: windowScene)
		//				window.rootViewController = SplashViewController()
		let vc = UIViewController()
		vc.view.backgroundColor = .red
		window.rootViewController = vc
		self.window = window
		window.makeKeyAndVisible()
	}
	
	func sceneDidDisconnect(_ scene: UIScene) { }
	
	func sceneDidBecomeActive(_ scene: UIScene) { }
	
	func sceneWillResignActive(_ scene: UIScene) { }
	
	func sceneWillEnterForeground(_ scene: UIScene) { }
	
	func sceneDidEnterBackground(_ scene: UIScene) { }
}
