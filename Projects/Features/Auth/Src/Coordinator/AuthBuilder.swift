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

  public init() { }

  public func build(rootViewController: ViewControllable) -> AuthCoordinating {
    let coordinator = AuthCoordinator(viewControllable: rootViewController)

    return coordinator
  }
}
