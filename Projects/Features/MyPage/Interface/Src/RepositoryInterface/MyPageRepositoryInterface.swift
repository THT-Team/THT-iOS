//
//  MyPageRepositoryInterface.swift
//  ChatInterface
//
//  Created by SeungMin on 1/16/24.
//

import Foundation
import RxSwift
import RxCocoa

import SignUpInterface
import AuthInterface

import RxSwift
import RxCocoa

public protocol MyPageRepositoryInterface {
  func fetchUser() -> Single<User>
  func fetchUserContacts() -> Single<Int>
  func updateUserContacts(contacts: [ContactType]) -> Single<Int>
  func updateAlarmSetting(_ settings: [String: Bool]) -> Completable
}

public class MockMyPageRepository: MyPageRepositoryInterface {
  public init() { }

  public func fetchUser() -> Single<User> {
    .just(User(preferGender: .male, username: "test", userUUID: "", age: 99, introduction: "self introduce", address: "seoul sungbuk", phoneNumber: "01089191234", email: "teset@tht.com", gender: .female, tall: 170, smoking: .none, drinking: .none, religion: .buddhism, idealTypeList: [.init(index: 1, name: "멋진", emojiCode: "#2425fa")], interestsList: [], userProfilePhotos: [], userAgreements: [:]))
  }

  public func fetchUserContacts() -> Single<Int> {
    return .just(100)
  }

  public func updateUserContacts(contacts: [ContactType]) -> Single<Int> {
    .just(100)
  }

  public func updateAlarmSetting(_ settings: [String : Bool]) -> Completable {
    return Completable.create { completable in
      completable(.completed)
      return Disposables.create()
    }.delay(.seconds(1), scheduler: MainScheduler.instance)
  }
}
