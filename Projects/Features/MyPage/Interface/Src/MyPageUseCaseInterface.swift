//
//  MyPageUseCaseInterface.swift
//  ChatInterface
//
//  Created by SeungMin on 1/16/24.
//

import Foundation
import RxSwift

public protocol MyPageUseCaseInterface {
  func fetchUser() -> Single<User>
  func fetchUserContacts() -> Single<Int>
  func updateUserContact() -> Single<Int>
}
