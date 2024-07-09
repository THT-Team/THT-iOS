//
//  SignUpReq.swift
//  SignUpInterface
//
//  Created by Kanghos on 2024/04/25.
//

import Foundation
import AuthInterface

extension UserInfo {
  public func toRequest(contacts: [ContactType]) -> SignUpReq? {
    guard 
      let username = self.name,
      let email = self.email,
      let gender = self.gender?.rawValue,
      let preferGender = self.preferGender?.rawValue,
      let birthday = self.birthday,
      let introduction = self.introduction,
      let agreement = self.userAgreements,
      let location = self.address,
      let tall = self.tall,
      let drinking = self.drinking?.rawValue,
      let smoking = self.smoking?.rawValue,
      let religion = self.religion?.rawValue

    else { return nil }

    return SignUpReq(
      phoneNumber: self.phoneNumber,
      username: username,
      email: email,
      birthDay: birthday,
      gender: gender,
      preferGender: preferGender,
      introduction: introduction,
      deviceKey: "device-key",
      agreement: agreement,
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
