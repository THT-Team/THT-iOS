//
//  MySettingBuilder.swift
//  MyPageInterface
//
//  Created by Kanghos on 6/15/24.
//

import Foundation
import MyPageInterface
import AuthInterface

import Core

public protocol MySettingDependency: MySettingCoordinatorDependency {

}

public final class MySettingBuilder: MySettingBuildable {
  private let dependency: MySettingDependency

  public init(dependency: MySettingDependency) {
    self.dependency = dependency
  }

  public func build(rootViewControllable: ViewControllable, user: User) -> MySettingCoordinating {
    MySettingCoordinator(
      viewControllable: rootViewControllable, user: user,
      dependency: dependency
    )
  }
}
