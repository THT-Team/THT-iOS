//
//  AppRootBuilder.swift
//  Feature
//
//  Created by Kanghos on 2023/12/06.
//

import UIKit

import Domain
import Feature
import DSKit

public protocol AppRootBuildable {
  func build() -> (LaunchCoordinating & URLHandling)
}

public final class AppRootBuilder: AppRootBuildable {

  public init() { }

  public func build() -> (LaunchCoordinating & URLHandling) {
    return AppCoordinator(
      viewControllable: ProgressNavigationViewControllable(),
      mainBuildable:  MainBuilder(),
      authBuildable: AuthBuilder(signUpBuilder: SignUpBuilder())
    )
  }
}

