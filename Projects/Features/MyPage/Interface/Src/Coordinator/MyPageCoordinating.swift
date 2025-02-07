//
//  MyPageCoordinating.swift
//  ChatInterface
//
//  Created by SeungMin on 1/16/24.
//

import Foundation
import SignUpInterface

import Core

public protocol MyPageCoordinating: Coordinator {
  var finishFlow: (() -> Void)? { get set }

  func homeFlow()

  func editNicknameFlow(nickname: String)
}
