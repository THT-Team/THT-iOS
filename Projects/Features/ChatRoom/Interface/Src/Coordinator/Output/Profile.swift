//
//  Profile.swift
//  ChatRoom
//
//  Created by Kanghos on 2/27/25.
//

import Foundation

public protocol ProfileOutput {
  var onDismiss: ((Bool) -> Void)? { get set }
  var handler: ProfileOutputHandler? { get set }
}

public enum ProfileOutputAction {
  case toast(String)
  case cancel
}

public typealias ProfileOutputHandler = ((ProfileOutputAction) -> Void)
