//
//  UserResponse.swift
//  Falling
//
//  Created by SeungMin on 2023/10/06.
//

struct UserResponse: Codable {
  let userList: [UserDTO]
}

struct UserDTO: Codable {
  let userIdx: Int
//  enum CodingKeys: CodingKey {
//    
//  }
}

struct UserSectionMapper {
  static func map(list: [UserDTO]) -> [UserSection] {
    let mutableSection: [UserSection] = []
    return mutableSection
  }
}
