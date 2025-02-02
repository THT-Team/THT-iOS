//
//  ChatCoordinating.swift
//  ChatInterface
//
//  Created by Kanghos on 2024/01/11.
//

import Foundation

import Core
import Domain

public protocol ChatCoordinatorDelegate: AnyObject {

}

public protocol ChatCoordinating: Coordinator {
  var delegate: ChatCoordinatorDelegate? { get set }

  func homeFlow()
  func chatRoomFlow(_ room: ChatRoom)
}
