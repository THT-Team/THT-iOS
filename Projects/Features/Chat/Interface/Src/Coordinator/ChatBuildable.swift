//
//  ChatBuildable.swift
//  ChatInterface
//
//  Created by Kanghos on 2024/01/11.
//

import Foundation

import Core
import DSKit

public protocol ChatBuildable {
  func build(rootViewControllable: ViewControllable) -> ChatCoordinating
}
