//
//  MockSignUpViewModel.swift
//  SignUp
//
//  Created by Kanghos on 2023/12/07.
//

import Foundation

import Core


final class MockSignUpViewModel {
  weak var delegate: SignUpHomeDelegate?

  init() {
    TFLogger.ui.debug("\(#function) \(type(of: self))")
  }

  deinit {
    TFLogger.ui.debug("\(#function) \(type(of: self))")
  }
  func test() {
    self.delegate?.signUpSuccess()
  }
}
