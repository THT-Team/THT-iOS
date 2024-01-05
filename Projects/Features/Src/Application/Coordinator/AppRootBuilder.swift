//
//  AppRootBuilder.swift
//  Feature
//
//  Created by Kanghos on 2023/12/06.
//

import UIKit

import Core
import DSKit
import SignUp
import SignUpInterface

public protocol AppRootBuildable {
  func build() -> LaunchCoordinating
}

public final class AppRootBuilder: AppRootBuildable {
  public init() { }

  lazy var mainBuildable: MainBuildable = {
    MainBuilder()
  }()

  lazy var signUpBuildable: SignUpBuildable = {
    SignUpBuilder()
  }()

  public func build() -> LaunchCoordinating {

    let viewController = TFLaunchViewController() 

    let coordinator = AppCoordinator(
      viewControllable: viewController,
      mainBuildable: self.mainBuildable,
      signUpBuildable: self.signUpBuildable
    )
    return coordinator
  }
}

