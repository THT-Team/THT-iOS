//
//  AuthBuildable.swift
//  AuthInterface
//
//  Created by Kanghos on 5/8/24.
//

import Foundation

import Core

public protocol AuthBuildable {
  func build(_ viewControllable: ViewControllable) -> AuthCoordinating
}
