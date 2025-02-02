//
//  DomainMessage.swift
//  Domain
//
//  Created by Kanghos on 2/1/25.
//

import Foundation

public enum DomainMessage {
  case incoming(ChatMessage)
  case outgoing(ChatMessage)
}
