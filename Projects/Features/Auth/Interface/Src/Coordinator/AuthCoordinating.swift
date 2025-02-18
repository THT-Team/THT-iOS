//
//  AuthCoordinating.swift
//  AuthInterface
//
//  Created by Kanghos on 5/8/24.
//

import Foundation

import Core
import Domain

public protocol AuthCoordinating: Coordinator {
  var finishFlow: (() -> Void)? { get set }

  var phoneNumberVerified: ((String) -> Void)? { get set }

  func rootFlow()
}
