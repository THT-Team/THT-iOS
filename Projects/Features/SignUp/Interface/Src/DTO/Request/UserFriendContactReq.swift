//
//  BlockRes.swift
//  SignUpInterface
//
//  Created by kangho lee on 5/2/24.
//

import Foundation

import Domain
import AuthInterface

public struct UserFriendContactReq: Codable {
  public let contacts: [ContactType]

  public init(contacts: [ContactType]) {
    self.contacts = contacts
  }
}
