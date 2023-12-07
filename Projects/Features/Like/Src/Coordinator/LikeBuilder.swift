//
//  LikeBuilder.swift
//  LikeInterface
//
//  Created by Kanghos on 2023/12/06.
//

import Foundation

import LikeInterface
import Core

public final class LikeBuilder: LikeBuildable {

  public init() { }
  public func build(rootViewControllable: ViewControllable) -> LikeCoordinating {

    let coordinator = LikeCoordinator(viewControllable: rootViewControllable)

    return coordinator
  }
}
