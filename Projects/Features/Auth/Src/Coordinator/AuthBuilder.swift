//
//  SignUpBuilder.swift
//  AuthInterface
//
//  Created by Kanghos on 5/8/24.
//

import UIKit

import SignUpInterface
import AuthInterface

import DSKit
import Core

public final class AuthBuilder: AuthBuildable {
  private let signUpBuilder: SignUpBuildable

  public init(signUpBuilder: SignUpBuildable) {
    self.signUpBuilder = signUpBuilder
  }

  public func build(_ viewControllable: ViewControllable) -> AuthCoordinating {
    AuthCoordinator(viewControllable: viewControllable, signUpBuilder: signUpBuilder)
  }
}
