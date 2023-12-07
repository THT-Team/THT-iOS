//
//  LikeCoordinating.swift
//  LikeInterface
//
//  Created by Kanghos on 2023/12/06.
//

import Foundation

import Core

public protocol LikeCoordinatorDelegate: AnyObject {
  func test(_ coordinator: Coordinator)

}
public protocol LikeCoordinating: Coordinator {
  var delegate: LikeCoordinatorDelegate? { get set }

  func homeFlow()
  func chatRoomFlow()
  func detailFlow()
}
