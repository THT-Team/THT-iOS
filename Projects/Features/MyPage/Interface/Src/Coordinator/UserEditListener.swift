//
//  UserEditListener.swift
//  MyPageInterface
//
//  Created by Kanghos on 7/30/24.
//

import Foundation
import Domain

public protocol UserEditListener: AnyObject {
  func sendData(user: User)
}
