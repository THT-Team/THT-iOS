//
//  ChatRoomCoordinating.swift
//  ChatRoom
//
//  Created by Kanghos on 1/6/25.
//

import Foundation
import Core

public protocol ChatRoomCoordinating: Coordinator {
  func chatRoomFlow(_ id: String)
  var finishFlow: ((String?) -> Void)? { get set }
}
