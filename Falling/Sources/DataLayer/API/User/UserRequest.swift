//
//  UserRequest.swift
//  Falling
//
//  Created by Kanghos on 2023/07/10.
//

import Foundation

struct SignUpRequest: Codable {
    let phoneNumber, username, email, birthDay: String
    let gender, preferGender: Gender
    let introduction, deviceKey: String
    let agreement: Agreement
    let locationRequest: LocationRequest
    let photoList: [String]
    let interestList, idealTypeList: [Int]
    let snsType, snsUniqueID: String

    enum CodingKeys: String, CodingKey {
        case phoneNumber, username, email, birthDay, gender, preferGender, introduction, deviceKey, agreement, locationRequest, photoList, interestList, idealTypeList, snsType
        case snsUniqueID = "snsUniqueId"
    }
}

// MARK: - Agreement
struct Agreement: Codable {
    let serviceUseAgree, personalPrivacyInfoAgree, locationServiceAgree, marketingAgree: Bool
}

// MARK: - LocationRequest
struct LocationRequest: Codable {
    let address: String
    let regionCode: Int
    let lat, lon: Double
}

enum Gender: String, Codable {
    case male = "MALE"
    case female = "FEMALE"
}
