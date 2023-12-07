//
//  SignUpBuildable.swift
//  SignUpInterface
//
//  Created by Kanghos on 2023/12/06.
//

import Foundation

import Core

public protocol SignUpBuildable {
  func build(rootViewController: ViewControllable) -> SignUpCoordinating
}
