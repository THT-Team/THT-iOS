//
//  AppBuilder.swift
//  AuthDemo
//
//  Created by Kanghos on 6/3/24.
//

import UIKit

import DSKit

import Auth
import AuthInterface
import SignUp
import SignUpInterface

public protocol AppRootBuildable {
  func build() -> LaunchCoordinating
}

public final class AppRootBuilder: AppRootBuildable {
  public init() { }

  private lazy var signUpBuildable: SignUpBuildable = {
    SignUpBuilder()
  }()

  private lazy var authBuildable: AuthBuildable = {
    AuthBuilder(signUpBuilable: signUpBuildable, inquiryBuildable: InquiryBuilder())
  }()

  private lazy var launchBuildable: LaunchBuildable = {
    LaunchBuilder()
  }()

  public func build() -> LaunchCoordinating {

    // MARK: Launcher

    let viewController =  NavigationViewControllable()

    let coordinator = AppCoordinator(
      viewControllable: viewController,
      authBuildable: self.authBuildable, 
      launchBuildable: launchBuildable
    )

    return coordinator
  }
}

