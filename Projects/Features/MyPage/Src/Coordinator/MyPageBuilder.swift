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

  public init() { }
  public func build(rootViewControllable: ViewControllable) -> MyPageCoordinating {

    let coordinator = MyPageCoordinator(viewControllable: rootViewControllable)

    return coordinator
  }
}
