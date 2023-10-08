//
//  HeartUserResponse.swift
//  Falling
//
//  Created by Kanghos on 2023/09/17.
//

import Foundation

// MARK: - UserResponse
struct HeartUserResponse: Codable {
    let username, userUUID: String
    let age: Int
    let introduction, address, phoneNumber, email: String
    let idealTypeList, interestsList: [EmojiType]
    let userProfilePhotos: [UserProfilePhoto]

    enum CodingKeys: String, CodingKey {
        case username
        case userUUID = "userUuid"
        case age, introduction, address, phoneNumber, email, idealTypeList, interestsList, userProfilePhotos
    }

  var description: String {
    username + ", " + "\(age)"
  }
}

// MARK: - List
struct EmojiType: Codable {
  let identifier = UUID()
    let idx: Int
    let name, emojiCode: String
}

// MARK: - UserProfilePhoto
struct UserProfilePhoto: Codable {
  let url: String
  let priority: Int
}

