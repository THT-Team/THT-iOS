//
//  AppDelegate.swift
//  App
//
//  Created by Hoo's MacBookPro on 12/3/23.
//

import UIKit
import Data
import Core
import Auth
import KakaoSDKCommon
import KakaoSDKUser

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    print(Configuration.kakaoNativeAppKey)
//    registerKakaoSDK(key: Configuration.kakaoNativeAppKey)
    KakaoSDK.initSDK(appKey: Configuration.kakaoNativeAppKey)
    print("isAvailable: \(UserApi.isKakaoTalkLoginAvailable())")
    registerDependencies()
    registerFirebase()
		return true
	}
	
	// MARK: UISceneSession Lifecycle
	func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
		// Called when a new scene session is being created.
		// Use this method to select a configuration to create the new scene with.
		return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
	}
  
//  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//    let token = deviceToken.reduce("") { $0 + String(format: "%02x", $1) }
//    TFLogger.dataLogger.notice("\(token)")
//    UserDefaultRepository.shared.save(token, key: .deviceKey)
//  }

  func registerKakaoSDK(key: String) {
    KakaoSDK.initSDK(appKey: key, loggingEnable: true)
  }
}
