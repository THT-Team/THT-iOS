//
//  ChatUseCaseInterface.swift
//  ChatInterface
//
//  Created by Kanghos on 2024/01/11.
//

import Foundation

import RxSwift

public protocol ChatUseCaseInterface {
  func fetchRooms() -> Single<[ChatRoom]>
}
