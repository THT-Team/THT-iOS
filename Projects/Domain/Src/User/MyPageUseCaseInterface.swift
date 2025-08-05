//
//  MyPageUseCaseInterface.swift
//  ChatInterface
//
//  Created by SeungMin on 1/16/24.
//

import Foundation
import RxSwift
import Core

public protocol MyPageUseCaseInterface {
  func fetchUser() -> Single<User>
  func fetchUserContacts() -> Single<Int>
  func updateUserContact() -> Single<Int>
  func fetchAlarmSetting() -> AlarmSetting
  func saveAlarmSetting(_ alarmSetting: AlarmSetting) -> Completable
  func updateLocation(_ location: LocationReq) -> Single<Void>
  func logout() -> Single<Void>
  func withdrawal(reason: String, feedback: String) -> Single<Void>
  
  func createSettingMenu(user: User) -> [SectionModel<MySetting.MenuItem>]

  func updateNickname(_ nickname: String) -> Single<Void>
  func checkNickname(_ nickname: String) -> Single<Bool>

  func updateIntroduce(_ introduce: String) -> Single<Void>
  func updateHeight(_ height: Int) -> Single<Void>
  func updatePreferGender(_ gender: Gender) -> Single<Void>
  
  func updateSmoking(_ frequency: Frequency) -> Single<Void>
  func updateDrinking(_ frequency: Frequency) -> Single<Void>
  func updateReligion(_ religion: Religion) -> Single<Void>
  
  func updatePhoneNumber(_ phoneNumber: String) -> Single<Void>
  func updateEmail(_ email: String) -> Single<Void>
  func updateInterest(_ interest: [EmojiType]) -> Single<Void>
  func updateIdealType(_ idealType: [EmojiType]) -> Single<Void>

  func updateProfilePhoto(_ photos: [UserProfilePhoto]) -> Single<Void>

  // MARK: ImageService
  func updateImage(_ data: Data, priority: Int) -> Single<UserProfilePhoto>
  func processImage(_ result: PhotoItem) -> Single<Data>
  
  func inquiry(email: String, content: String, isEmailAgree: Bool) -> Single<Void>
}
