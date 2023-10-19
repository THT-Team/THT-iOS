//
//  SignupUserDefault.swift
//  Falling
//
//  Created by Hoo's MacBookPro on 10/16/23.
//

import Foundation

final class SignupUserDefault {
	static let shared = SignupUserDefault()
	
	private init() { }
	
	enum Key: String {
		case phoneNumber
		case email
		case serviceUseAgree
		case personalPrivacyInfoAgree
		case locationServiceAgree
		case marketingAgree
	}
	
	@DataStorage(key: Key.phoneNumber.rawValue, defaultValue: "")
	var phoneNumber: String
	
	@DataStorage(key: Key.email.rawValue, defaultValue: "")
	var email: String
	
	@DataStorage(key: Key.serviceUseAgree.rawValue, defaultValue: false)
	var serviceUseAgree: Bool
	
	@DataStorage(key: Key.personalPrivacyInfoAgree.rawValue, defaultValue: false)
	var personalPrivacyInfoAgree: Bool
	
	@DataStorage(key: Key.locationServiceAgree.rawValue, defaultValue: false)
	var locationServiceAgree: Bool
	
	@DataStorage(key: Key.marketingAgree.rawValue, defaultValue: false)
	var marketingAgree: Bool
}
