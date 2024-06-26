//
//  MySettingBuilder.swift
//  MyPageInterface
//
//  Created by Kanghos on 6/15/24.
//

import Foundation
import MyPageInterface

import Core

public final class MySettingBuilder: MySettingBuildable {
  private let myPageAlertBuildable: MyPageAlertBuildable

  public init(myPageAlertBuildable: MyPageAlertBuildable) {
    self.myPageAlertBuildable = myPageAlertBuildable
  }

  public func build(rootViewControllable: ViewControllable, user: User) -> MySettingCoordinating {
    MySettingCoordinator(viewControllable: rootViewControllable, user: user, myPageAlertBuildable: self.myPageAlertBuildable)
  }
}
