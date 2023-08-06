//
//  PhoneValidationResponse.swift
//  Falling
//
//  Created by Hoo's MacBookPro on 2023/08/07.
//

import Foundation

struct PhoneValidationResponse: Codable {
	let phoneNumber: String
	let authNumber: Int
}
