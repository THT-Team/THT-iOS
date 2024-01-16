//
//  ChatRepositoryInterface.swift
//  ChatInterface
//
//  Created by Kanghos on 2024/01/11.
//

import Foundation

import RxSwift

public protocol ChatRepositoryInterface {
  func fetchRooms() -> Single<[ChatRoom]>
}
