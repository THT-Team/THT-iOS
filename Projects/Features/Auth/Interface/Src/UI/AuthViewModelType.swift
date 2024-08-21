//
//  AuthViewModelType.swift
//  AuthInterface
//
//  Created by kangho lee on 7/27/24.
//

import Foundation

import Core

public protocol AuthViewModelType: ViewModelType where Input: AuthInput, Output: AuthOutput {
  var delegate: PhoneAuthViewDelegate? { get set }
}

public protocol AuthOutput {
  var description: Driver<String> { get }
  var error: Driver<Error> { get }
  var certificateSuccess: Driver<Bool> { get }
  var certificateFailuer: Driver<Bool> { get }
  var timestamp: Driver<String> { get }
}

public protocol AuthInput {
  var viewWillAppear: Signal<Void> { get }
  var codeInput: Driver<String> { get }
  var finishAnimationTrigger: Signal<Void> { get }
  var resendBtnTap: Signal<Void> { get }
  init(viewWillAppear: Signal<Void>, codeInput: Driver<String>, finishAnimationTrigger: Signal<Void>, resendBtnTap: Signal<Void>)
}
