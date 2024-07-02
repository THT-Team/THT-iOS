//
//  AuthCoordinating.swift
//  AuthInterface
//
//  Created by Kanghos on 5/8/24.
//

import Foundation

import Core

public protocol AuthCoordinatingDelegate: AnyObject {
  func detachAuth(_ coordinator: Coordinator)
}

public protocol AuthCoordinating: Coordinator {
  var delegate: AuthCoordinatingDelegate? { get set }

  func launchFlow()

  func rootFlow()

  func phoneNumberFlow()

  func snsFlow(type: AuthType)
}
