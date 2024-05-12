//
//  UserInfo.swift
//  SignUpInterface
//
//  Created by Kanghos on 2024/04/25.
//

import Foundation
import Domain

public struct UserInfo {
  public let name: String
  public let userUUID: String
  public let age: Int
  public let introduction: String
  public let address: String
  public let phoneNumber: Int
  public let email: String
  public let gender: Gender
  public let preferGender: Gender
  public let tall: Int
  public let smoking: Frequency
  public let drinking: Frequency
  public let religion: Religion
  public let idealTypeList: [EmojiType]
  public let interestsList: [EmojiType]
  public let userProfilePhotos: [UserProfilePhoto]
  public let userAgreements: Agreement
}
