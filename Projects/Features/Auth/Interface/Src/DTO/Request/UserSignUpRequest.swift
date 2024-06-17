//
//  UserSignUpRequest.swift
//  AuthInterface
//
//  Created by Kanghos on 6/26/24.
//

import Foundation

public struct SignUpReq: Encodable {
  public let phoneNumber, username, email, birthDay: String
  public let gender, preferGender: String
  public let introduction, deviceKey: String
  public let agreement: [String: Bool]
  public let locationRequest: LocationReq
  public var photoList: [String]
  public let interestList, idealTypeList: [Int]
  public let snsType: String
  public let snsUniqueID: String
  public let tall: Int
  public let smoking: String
  public let drinking: String
  public let religion: String
  public let contacts: [ContactType]

  enum CodingKeys: String, CodingKey {
    case phoneNumber, username, email, birthDay, gender, preferGender, introduction, deviceKey, agreement, locationRequest, photoList, interestList, idealTypeList, snsType
    case snsUniqueID = "snsUniqueId"
    case tall, smoking, drinking, religion
    case contacts
  }

  public init(phoneNumber: String, username: String, email: String, birthDay: String, gender: String, preferGender: String, introduction: String, deviceKey: String, agreement: [String: Bool], locationRequest: LocationReq, photoList: [String], interestList: [Int], idealTypeList: [Int], snsType: String, snsUniqueID: String, tall: Int, smoking: String, drinking: String, religion: String, contacts: [ContactType]) {
    self.phoneNumber = phoneNumber
    self.username = username
    self.email = email
    self.birthDay = birthDay
    self.gender = gender
    self.preferGender = preferGender
    self.introduction = introduction
    self.deviceKey = deviceKey
    self.agreement = agreement
    self.locationRequest = locationRequest
    self.photoList = photoList
    self.interestList = interestList
    self.idealTypeList = idealTypeList
    self.snsType = snsType
    self.snsUniqueID = snsUniqueID
    self.tall = tall
    self.smoking = smoking
    self.drinking = drinking
    self.religion = religion
    self.contacts = contacts
  }
}
