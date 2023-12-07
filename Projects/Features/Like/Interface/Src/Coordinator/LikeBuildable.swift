//
//  LikeBuildable.swift
//  LikeInterface
//
//  Created by Kanghos on 2023/12/06.
//

import Foundation

import Core

public protocol LikeBuildable {
  func build(rootViewControllable: ViewControllable) -> LikeCoordinating
}
