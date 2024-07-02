//
//  MyPageBuilder.swift
//  ChatInterface
//
//  Created by SeungMin on 1/16/24.
//

import Foundation

import MyPageInterface
import AuthInterface
import Core

public protocol MyPageDependency {
  var inquiryBuildable: InquiryBuildable { get }
  var authViewFactory: AuthViewFactoryType { get }
}

final class MyPageComponent: MyPageDependency, MySettingDependency {
  lazy var myPageAlertBuildable: MyPageAlertBuildable = {
    MyPageAlertBuilder()
  }()
  var inquiryBuildable: InquiryBuildable { dependency.inquiryBuildable }
  var authViewFactory: AuthViewFactoryType { dependency.authViewFactory }
  lazy var mySettingBuildable: MySettingBuildable = {
    MySettingBuilder(dependency: self)
  }()

  let dependency: MyPageDependency

  init(dependency: MyPageDependency) {
    self.dependency = dependency
  }
}

public final class MyPageBuilder: MyPageBuildable {

  private let dependency: MyPageDependency

  public init(dependency: MyPageDependency) {
    self.dependency = dependency
  }

  public func build() -> MyPageCoordinating {
    let component = MyPageComponent(dependency: dependency)
    let coordinator = MyPageCoordinator(
      viewControllable: NavigationViewControllable(),
      mySettingBuildable: component.mySettingBuildable
    )

    return coordinator
  }
}
