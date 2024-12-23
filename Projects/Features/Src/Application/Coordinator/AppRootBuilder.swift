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
import MyPage

public protocol AppRootDependency { }

final class AppRootComponent: AppRootDependency, MyPageDependency {
  lazy var inquiryBuildable: AuthInterface.InquiryBuildable = {
    InquiryBuilder()
  }()

  lazy var authViewFactory: AuthInterface.AuthViewFactoryType = {
    AuthViewFactory()
  }()

  private let dependency: AppRootDependency

  init(dependency: AppRootDependency) {
    self.dependency = dependency
  }
}

public protocol AppRootBuildable {
  func build() -> (LaunchCoordinating & URLHandling)
}

public final class AppRootBuilder: AppRootBuildable {
  private let dependency: AppRootDependency

  public init(dependency: AppRootDependency) {
    self.dependency = dependency
  }

  public func build() -> (LaunchCoordinating & URLHandling) {

    let viewController = NavigationViewControllable()

    let component = AppRootComponent(dependency: dependency)
    let mainBuilder = MainBuilder(dependency: component)
    let authBuilder = AuthBuilder()
    let launcher = LaunchBuilder()

    let coordinator = AppCoordinator(
      viewControllable: viewController,
      mainBuildable: mainBuilder,
      authBuildable: authBuilder,
      launchBUidlable: launcher,
      signUpBuildable: SignUpBuilder()
    )
    return coordinator
  }
}

