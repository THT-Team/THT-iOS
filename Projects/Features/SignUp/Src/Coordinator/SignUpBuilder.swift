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
  
  public func build(rootViewControllable: ViewControllable) -> SignUpCoordinating {
    let coordinator = SignUpCoordinator(viewControllable: rootViewControllable)
    return coordinator
  }
}
