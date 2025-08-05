//
//  MyPageRepositoryInterface.swift
//  ChatInterface
//
//  Created by SeungMin on 1/16/24.
//

import Foundation

import RxSwift

public protocol UserRepositoryInterface {
  func fetchUser() -> Single<User>
  func fetchUserContacts() -> Single<Int>
  func updateUserContacts(contacts: [ContactType]) -> Single<Int>
  func updateAlarmSetting(_ settings: [String: Bool]) -> Single<Void>
  func logout() -> Single<Void>
  func withdrawal(reason: String, feedback: String) -> Single<Void>
  func updateLocation(_ location: LocationReq) -> Single<Void>

  func updateReligion(_ religion: Religion) -> Single<Void>
  func updateSmoking(_ smoking: Frequency) -> Single<Void>
  func updateDrinking(_ drinking: Frequency) -> Single<Void>
  func updatePreferGender(_ gender: Gender) -> Single<Void>
  func updateNickname(_ nickname: String) -> Single<Void>
  func updateIntroduction(_ introduction: String) -> Single<Void>
  func updateHeight(_ height: Int) -> Single<Void>
  func updateIdealType(_ emojies: [EmojiType]) -> Single<Void>
  func updateInterests(_ emojies: [EmojiType]) -> Single<Void>
  func updateProfilePhotos(_ photos: [UserProfilePhoto]) -> Single<Void>
  func updatePhoneNumber(_ phoneNumber: String) -> Single<Void>
  func updateEmail(_ email: String) -> Single<Void>
  func updateDeviceToken(_ deviceKey: String) -> Single<Void>
  
  func inquiry(email: String, content: String, isEmailAgree: Bool) -> Single<Void>
}
