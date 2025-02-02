//
//  ChatRoomCoordinating.swift
//  ChatRoom
//
//  Created by Kanghos on 1/6/25.
//

import Foundation
import Core

public protocol ChatRoomCoordinating: Coordinator, CoordinatorOutput {
  func chatRoomFlow(_ id: String)
}
