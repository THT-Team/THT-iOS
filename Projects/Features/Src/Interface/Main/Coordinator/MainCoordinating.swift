//
//  MainCoordinating.swift
//  Feature
//
//  Created by Kanghos on 2023/12/06.
//

import Foundation

import Core

public protocol MainCoordinatorDelegate: AnyObject {
  func detachTab(_ coordinator: Coordinator)
}

protocol MainCoordinating: Coordinator {
  var delegate: MainCoordinatorDelegate? { get set }

  func attachTab()
  func detachTab()
}
