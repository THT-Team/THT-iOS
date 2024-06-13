//
//  LaunchBuildable.swift
//  Auth
//
//  Created by Kanghos on 6/4/24.
//

import Foundation

import Core

public protocol LaunchBuildable {
  func build(rootViewControllable: ViewControllable) -> AuthLaunchCoordinating
}
