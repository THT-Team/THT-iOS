//
//  LaunchBuilder.swift
//  Auth
//
//  Created by Kanghos on 6/4/24.
//

import Foundation
import Core
import AuthInterface

public final class LaunchBuilder: LaunchBuildable {

  public init() { }

  public func build(rootViewControllable: ViewControllable) -> AuthLaunchCoordinating {
    let coordinator = AuthLaunchCoordinator(viewControllable: rootViewControllable)
    return coordinator
  }
}
