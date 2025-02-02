//
//  LikeCoordinating.swift
//  LikeInterface
//
//  Created by Kanghos on 2023/12/06.
//

import Foundation

import Core

public protocol LikeCoordinating: Coordinator {
  var finishFlow: (() -> Void)? { get set }

  func homeFlow()
  func chatRoomFlow(_ userUUID: String)
}
