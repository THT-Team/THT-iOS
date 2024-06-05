//
//  AppRootBuilder.swift
//  Feature
//
//  Created by Kanghos on 2023/12/06.
//

import UIKit

import Core
import DSKit
import Auth
import SignUp

public protocol AppRootBuildable {
  func build() -> LaunchCoordinating
}

public final class AppRootBuilder: AppRootBuildable {
  public init() { }

  private lazy var mainBuildable: MainBuildable = {
    MainBuilder()
  }()

  private lazy var signUpBuildable: SignUpBuildable = {
    SignUpBuilder()
  }()

  private lazy var authBuildable: AuthBuildable = {
    AuthBuilder(signUpBuilable: signUpBuildable)
  }()

  private lazy var launchBuildable: LaunchBuildable = {
    LaunchBuilder()
  }()

  public func build() -> LaunchCoordinating {

    let viewController = NavigationViewControllable()

    let coordinator = AppCoordinator(
      viewControllable: viewController,
      mainBuildable: self.mainBuildable,
      authBuildable: self.authBuildable,
      launchBUidlable: self.launchBuildable
    )
    return coordinator
  }
}

