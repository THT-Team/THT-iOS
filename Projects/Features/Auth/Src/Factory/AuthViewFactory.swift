//
//  AuthViewFactory.swift
//  Auth
//
//  Created by Kanghos on 8/20/24.
//

import UIKit
import AuthInterface
import DSKit

public final class AuthViewFactory {
  @Injected private var useCase: AuthUseCaseInterface

  public init() { }
}

extension AuthViewFactory: AuthViewFactoryType {
  public func makePhoneAuthScene(viewModel: some AuthViewModelType) -> any AuthVCType {
    PhoneAuthVC(viewModel: viewModel)
  }

  public func makePhoneNumberScene(delegate: PhoneInputVCDelegate) -> any PhoneNumberVCType {
    PhoneInputVC(
      viewModel: PhoneInputVM(delegate: delegate, useCase: useCase)
    )
  }
}
