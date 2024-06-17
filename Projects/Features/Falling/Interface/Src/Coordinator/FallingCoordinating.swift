//
//  FallingCoordinating.swift
//  LikeInterface
//
//  Created by Kanghos on 2023/12/06.
//

import Foundation

import Core

public protocol FallingCoordinatorDelegate: AnyObject {
  

}
public protocol FallingCoordinating: Coordinator {
  var delegate: FallingCoordinatorDelegate? { get set }

  func homeFlow()
  func chatRoomFlow()
}
