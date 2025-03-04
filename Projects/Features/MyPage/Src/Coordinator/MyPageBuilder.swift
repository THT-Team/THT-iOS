//
//  MyPageBuilder.swift
//  ChatInterface
//
//  Created by SeungMin on 1/16/24.
//

import Foundation

import MyPageInterface
import Core

public typealias MyPageDependency = SignUpBottomSheetFactoryType & MyPageFactoryType & MySettingBuildable

public final class MyPageBuilder: MyPageBuildable {
  private let factory: MyPageDependency

  public init(factory: MyPageDependency) {
    self.factory = factory
  }
  public func build(rootViewControllable: (any ViewControllable)) -> any MyPageCoordinating {
    MyPageCoordinator(viewControllable: rootViewControllable, factory: factory)
  }
}
