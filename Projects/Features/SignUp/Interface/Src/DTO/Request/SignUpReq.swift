//
//  SignUpReq.swift
//  SignUpInterface
//
//  Created by Kanghos on 2024/04/25.
//

import Foundation
import AuthInterface
import Domain

extension PendingUser {
  public func toRequest(contacts: [ContactType], deviceKey: String) -> SignUpReq? {
    guard
      let username = self.name,
      let email = self.email,
      let gender = self.gender?.rawValue,
      let preferGender = self.preferGender?.rawValue,
      let birthday = self.birthday,
      let introduction = self.introduction,
      let location = self.address,
      let tall = self.tall,
      let drinking = self.drinking?.rawValue,
      let smoking = self.smoking?.rawValue,
      let religion = self.religion?.rawValue,
      self.userAgreements.isEmpty == false

    else { return nil }

    return SignUpReq(
      phoneNumber: self.phoneNumber,
      username: username,
      email: email,
      birthDay: birthday,
      gender: gender,
      preferGender: preferGender,
      introduction: introduction,
      deviceKey: deviceKey,
      agreement: self.userAgreements,
      locationRequest: location,
      photoList: photos,
      interestList: interestsList,
      idealTypeList: idealTypeList,
      snsType: SNSType.normal.rawValue,
      snsUniqueID: "",
      tall: tall,
      smoking: smoking,
      drinking: drinking,
      religion: religion,
      contacts: contacts
    )
  }
}
