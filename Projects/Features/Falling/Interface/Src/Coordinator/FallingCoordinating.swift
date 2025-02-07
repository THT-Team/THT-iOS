//
//  FallingCoordinating.swift
//  LikeInterface
//
//  Created by Kanghos on 2023/12/06.
//

import Foundation

import Core
import Domain

public protocol FallingCoordinating: Coordinator {
  func homeFlow()
  func chatRoomFlow(_ index: String)
  func toMatchFlow(_ imageURL: String, index: String)
}
