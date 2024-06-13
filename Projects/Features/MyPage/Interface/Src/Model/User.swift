//
//  User.swift
//  MyPage
//
//  Created by Kanghos on 6/6/24.
//

import Foundation
import Domain
import SignUpInterface

public struct User {
  public let preferGender: Gender
  public let username, userUUID: String
  public let age: Int
  public let introduction, address, phoneNumber, email: String
  public let gender: Gender
  public let tall: Int
  public let smoking, drinking: Frequency
  public let religion: Religion
  public let idealTypeList, interestsList: [SignUpInterface.EmojiType]
  public let userProfilePhotos: [Domain.UserProfilePhoto]
  public let userAgreements: [String: Bool]

  public init(preferGender: Gender, username: String, userUUID: String, age: Int, introduction: String, address: String, phoneNumber: String, email: String, gender: Gender, tall: Int, smoking: Frequency, drinking: Frequency, religion: Religion, idealTypeList: [SignUpInterface.EmojiType], interestsList: [SignUpInterface.EmojiType], userProfilePhotos: [Domain.UserProfilePhoto], userAgreements: [String : Bool]) {
    self.preferGender = preferGender
    self.username = username
    self.userUUID = userUUID
    self.age = age
    self.introduction = introduction
    self.address = address
    self.phoneNumber = phoneNumber
    self.email = email
    self.gender = gender
    self.tall = tall
    self.smoking = smoking
    self.drinking = drinking
    self.religion = religion
    self.idealTypeList = idealTypeList
    self.interestsList = interestsList
    self.userProfilePhotos = userProfilePhotos
    self.userAgreements = userAgreements
  }
}
