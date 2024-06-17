//
//  UserInfo.swift
//  SignUpInterface
//
//  Created by Kanghos on 2024/04/25.
//

import Foundation
import Domain

import AuthInterface

public struct UserInfo: Codable {
  public var phoneNumber: String
  public var name: String?
  public var userUUID: String?
  public var birthday: String?
  public var introduction: String?
  public var address: LocationReq?
  public var email: String?
  public var gender: Gender?
  public var preferGender: Gender?
  public var tall: Int?
  public var smoking: Frequency?
  public var drinking: Frequency?
  public var religion: Religion?
  public var idealTypeList: [Int]
  public var interestsList: [Int]
  public var photos: [String]
  public var userAgreements: [String: Bool]?

  public init(phoneNumber: String, name: String? = nil, userUUID: String? = nil, birthday: String? = nil, introduction: String? = nil, address: LocationReq? = nil, email: String? = nil, gender: Gender? = nil, preferGender: Gender? = nil, tall: Int? = nil, smoking: Frequency? = nil, drinking: Frequency? = nil, religion: Religion? = nil, idealTypeList: [Int] = [], interestsList: [Int] = [], photos: [String] = [], userAgreements: [String: Bool]? = nil) {
    self.phoneNumber = phoneNumber
    self.name = name
    self.userUUID = userUUID
    self.birthday = birthday
    self.introduction = introduction
    self.address = address
    self.email = email
    self.gender = gender
    self.preferGender = preferGender
    self.tall = tall
    self.smoking = smoking
    self.drinking = drinking
    self.religion = religion
    self.idealTypeList = idealTypeList
    self.interestsList = interestsList
    self.photos = photos
    self.userAgreements = userAgreements
  }
}
