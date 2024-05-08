//
//  BlockRes.swift
//  SignUpInterface
//
//  Created by kangho lee on 5/2/24.
//

import Foundation

public struct UserFriendContactReq: Codable {
  public struct Contact: Codable {
    public let name: String
    public let phoneNumber: String
    
    public init(name: String, phoneNumber: String) {
      self.name = name
      self.phoneNumber = phoneNumber
    }
  }
  public let contacts: [Contact]
  
  public init(contacts: [Contact]) {
    self.contacts = contacts
  }
}
