//
//  RegexUtil.swift
//  Falling
//
//  Created by Hoo's MacBookPro on 2023/08/05.
//

import Foundation

enum Regex: String {
	case phoneNum = "^01[0-1,7][0-9]{7,8}$"
}

extension String {
	func phoneNumValidation() -> Bool {
		return (self.range(of: Regex.phoneNum.rawValue, options: .regularExpression) != nil)
	}
}
