//
//  ChatRoom.swift
//  ChatRoom
//
//  Created by Kanghos on 2/27/25.
//

import Foundation
import Domain

public protocol ChatRoomOutputType {
  var onExit: ((ConfirmHandler?) -> Void)? { get set }
  var onReport: ((UserReportHandler?) -> Void)? { get set }
  var onBack: ((String?) -> Void)? { get set }
  var onProfile: ((ProfileItem, ProfileOutputHandler?) -> Void)? { get set }
}
