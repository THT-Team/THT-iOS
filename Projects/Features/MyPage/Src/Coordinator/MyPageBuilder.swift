//
//  MyPageBuilder.swift
//  ChatInterface
//
//  Created by SeungMin on 1/16/24.
//

import Foundation

import MyPageInterface
import Core

public final class MyPageBuilder: MyPageBuildable {

  private let myPageAlertBuildable: MyPageAlertBuildable = MyPageAlertBuilder()

  private lazy var mySettingBuildable: MySettingBuildable = {
    return MySettingBuilder(myPageAlertBuildable: myPageAlertBuildable)
  }()


  public init() { }
  public func build(rootViewControllable: ViewControllable) -> MyPageCoordinating {

    let coordinator = MyPageCoordinator(viewControllable: rootViewControllable, mySettingBuildable: mySettingBuildable)

    return coordinator
  }
}
