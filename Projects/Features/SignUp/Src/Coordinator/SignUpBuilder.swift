//
//  SignUpBuilder.swift
//  SignUpInterface
//
//  Created by Kanghos on 2023/12/06.
//

import UIKit
import Core

import SignUpInterface

public final class SignUpBuilder: SignUpBuildable {
  public init() { }
  
  public func build() -> SignUpCoordinating {
    let rootViewController = NavigationViewControllable()
    let coordinator = SignUpCoordinator(viewControllable: rootViewController)
    return coordinator
  }
}
