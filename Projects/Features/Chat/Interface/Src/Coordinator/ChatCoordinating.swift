//
//  ChatCoordinating.swift
//  ChatInterface
//
//  Created by SeungMin on 1/16/24.
//

import Foundation

import Core

public protocol ChatCoordinatorDelegate: AnyObject {
  func test(_ coordinator: Coordinator)

}
public protocol ChatCoordinating: Coordinator {
  var delegate: ChatCoordinatorDelegate? { get set }

  func homeFlow()
}

