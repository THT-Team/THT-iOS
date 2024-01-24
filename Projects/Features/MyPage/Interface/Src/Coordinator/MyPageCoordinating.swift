//
//  MyPageCoordinating.swift
//  ChatInterface
//
//  Created by SeungMin on 1/16/24.
//

import Foundation

import Core

public protocol MyPageCoordinatorDelegate: AnyObject {
  func test(_ coordinator: Coordinator)

}
public protocol MyPageCoordinating: Coordinator {
  var delegate: MyPageCoordinatorDelegate? { get set }

  func homeFlow()
}

