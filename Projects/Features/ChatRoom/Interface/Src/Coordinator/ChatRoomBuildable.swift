//
//  ChatRoomBuildable.swift
//  ChatRoom
//
//  Created by Kanghos on 1/6/25.
//

import Foundation
import Domain
import Core

public protocol ChatRoomBuildable {
  func build(_ userUUID: String, rootViewControllable: ViewControllable, talkUseCase: TalkUseCaseInterface) -> ChatRoomCoordinating
}
