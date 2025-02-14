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
import Domain

public protocol AppRootDependency { }

public protocol AppRootBuildable {
  func build() -> (LaunchCoordinating & URLHandling)
}

public final class AppRootBuilder: AppRootBuildable {
  private let dependency: AppRootDependency

  public init(dependency: AppRootDependency) {
    self.dependency = dependency
  }

  public func build() -> (LaunchCoordinating & URLHandling) {
    AppCoordinator(
      viewControllable: ProgressNavigationViewControllable(),
      mainBuildable:  MainBuilder(),
      authBuildable: AuthBuilder(),
      signUpBuildable: SignUpBuilder()
    )
  }
}

