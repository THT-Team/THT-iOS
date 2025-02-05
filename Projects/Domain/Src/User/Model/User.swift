//
//  User.swift
//  MyPage
//
//  Created by Kanghos on 6/6/24.
//

import Foundation

public struct User: UserInfoType {
  public let age: Int
  public let birthday: String
  public let userUUID: String
  public let gender: Gender

  public var preferGender: Gender
  public var username: String
  public var introduction, address, phoneNumber, email: String
  public var tall: Int
  public var smoking, drinking: Frequency
  public var religion: Religion
  public var idealTypeList, interestsList: [EmojiType]
  public var userProfilePhotos: [Domain.UserProfilePhoto]
  public var userAgreements: [String: Bool]

  public init(birthday: String, preferGender: Gender, username: String, userUUID: String, age: Int, introduction: String, address: String, phoneNumber: String, email: String, gender: Gender, tall: Int, smoking: Frequency, drinking: Frequency, religion: Religion, idealTypeList: [EmojiType], interestsList: [EmojiType], userProfilePhotos: [Domain.UserProfilePhoto], userAgreements: [String : Bool]) {
    self.preferGender = preferGender
    self.birthday = birthday
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

public struct ProfileItem {
  public let id: String
  public let topic: String
  public let issue: String

  public init(id: String, topic: String, issue: String) {
    self.id = id
    self.topic = topic
    self.issue = issue
  }
}
