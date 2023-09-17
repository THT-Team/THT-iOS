//
//  LikeSection.swift
//  Falling
//
//  Created by Kanghos on 2023/09/13.
//

import Foundation

import RxDataSources

//// MARK: - LikeList
//struct LikeDTO: Codable {
//    let dailyFallingIdx, likeIdx: Int
//    let topic, issue, userUUID, username: String
//    let profileURL: String
//    let age: Int
//    let address, receivedTime: String
//
//    enum CodingKeys: String, CodingKey {
//        case dailyFallingIdx, likeIdx, topic, issue
//        case userUUID = "userUuid"
//        case username
//        case profileURL = "profileUrl"
//        case age, address, receivedTime
//    }
//}

struct LikeSection {
  var header: String
  var items: [Item]
}

extension LikeSection: AnimatableSectionModelType {
  typealias Item = LikeDTO
  var identity: String {
    return self.header
  }

  init(original: LikeSection, items: [Item]) {
    self = original
    self.items = items
  }
}

extension LikeDTO: IdentifiableType, Equatable {
  static func == (lhs: LikeDTO, rhs: LikeDTO) -> Bool {
    lhs.identity == rhs.identity
  }

  var identity: Int {
    return likeIdx
  }
}
