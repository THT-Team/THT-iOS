//
//  SignUpBuilder.swift
//  AuthInterface
//
//  Created by Kanghos on 5/8/24.
//

import Foundation
import Core

import SignUpInterface
import AuthInterface

public final class AuthBuilder: AuthBuildable {
  private let signUpBuilable: SignUpBuildable

  public init(signUpBuilable: SignUpBuildable) {
    self.signUpBuilable = signUpBuilable
  }

  public func build() -> AuthCoordinating {
    let rootViewController = NavigationViewControllable()
    let coordinator = AuthCoordinator(signUpBuildable: signUpBuilable, viewControllable: rootViewController)

    return coordinator
  }
}
