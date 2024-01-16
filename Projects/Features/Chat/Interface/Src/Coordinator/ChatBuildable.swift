//
//  ChatBuildable.swift
//  ChatInterface
//
//  Created by SeungMin on 1/16/24.
//

import Foundation

import Core

public protocol ChatBuildable {
  func build(rootViewControllable: ViewControllable) -> ChatCoordinating
}

