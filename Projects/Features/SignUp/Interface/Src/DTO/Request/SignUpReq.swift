//
//  SignUpReq.swift
//  SignUpInterface
//
//  Created by Kanghos on 2024/04/25.
//

import Foundation

public struct SignUpReq: Encodable {
  let phoneNumber, username, email, birthDay: String
  let gender, preferGender: Gender
  let introduction, deviceKey: String
  let agreement: Agreement
  let locationRequest: LocationReq
  let photoList: [String]
  let interestList, idealTypeList: [Int]
  let snsType: SNSType
  let snsUniqueID: String
  let tall: Int
  let smoking: Frequency
  let drinking: Frequency
  let religion: Religion

  enum CodingKeys: String, CodingKey {
    case phoneNumber, username, email, birthDay, gender, preferGender, introduction, deviceKey, agreement, locationRequest, photoList, interestList, idealTypeList, snsType
    case snsUniqueID = "snsUniqueId"
    case tall, smoking, drinking, religion
  }

  public init(phoneNumber: String, username: String, email: String, birthDay: String, gender: Gender, preferGender: Gender, introduction: String, deviceKey: String, agreement: Agreement, locationRequest: LocationReq, photoList: [String], interestList: [Int], idealTypeList: [Int], snsType: SNSType, snsUniqueID: String, tall: Int, smoking: Frequency, drinking: Frequency, religion: Religion) {
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
  }
}
