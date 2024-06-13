//
//  Regex+Util.swift
//  AuthInterface
//
//  Created by Kanghos on 5/8/24.
//

import Foundation

enum Regex: String {
  case phoneNum = "^01[0-1,7][0-9]{7,8}$"
  case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
}

extension String {
  func phoneNumValidation() -> Bool {
    return (self.range(of: Regex.phoneNum.rawValue, options: .regularExpression) != nil)
  }

  func emailValidation() -> Bool {
    return (self.range(of: Regex.email.rawValue, options: .regularExpression) != nil)
  }
}
