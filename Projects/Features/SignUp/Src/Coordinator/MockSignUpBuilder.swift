//
//  SignUpBuilder.swift
//  SignUpInterface
//
//  Created by Kanghos on 2023/12/06.
//

import UIKit
import Core

import SignUpInterface

public final class MockSignUpBuilder: SignUpBuildable {
  public init() { }
  
  public func build(rootViewController: ViewControllable) -> SignUpCoordinating {


    rootViewController.setViewControllers([])
    let coordinator = MockSignUpCoordinator(viewControllable: rootViewController)
    return coordinator
  }
}
