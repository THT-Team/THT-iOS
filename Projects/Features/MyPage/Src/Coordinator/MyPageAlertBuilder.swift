//
//  MyPageAlertBuilder.swift
//  MyPage
//
//  Created by Kanghos on 6/13/24.
//

import Foundation
import DSKit
import MyPageInterface

public final class MyPageAlertBuilder: MyPageAlertBuildable {

  public init() { }
  public func build(rootViewControllable: ViewControllable) -> MyPageAlertCoordinating {

    let coordinator = MyPageAlertCoordinator(viewControllable: rootViewControllable)

    return coordinator
  }
}
