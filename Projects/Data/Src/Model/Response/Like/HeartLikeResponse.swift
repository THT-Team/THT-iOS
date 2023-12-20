//
//  HeartLikeResponse.swift
//  Falling
//
//  Created by Kanghos on 2023/09/11.
//

import Foundation

import LikeInterface

struct HeartLikeResponse: Codable {
  let isMatching: Bool
  let chatRoomIdx: Int
}
