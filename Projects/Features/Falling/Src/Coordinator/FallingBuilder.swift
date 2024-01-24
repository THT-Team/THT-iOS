//
//  FallingBuilder.swift
//  FallingInterface
//
//  Created by SeungMin on 1/11/24.
//

import Foundation

import FallingInterface
import Core

public final class FallingBuilder: FallingBuildable {

  public init() { }
  public func build(rootViewControllable: ViewControllable) -> FallingCoordinating {

    let coordinator = FallingCoordinator(viewControllable: rootViewControllable)

    return coordinator
  }
}
