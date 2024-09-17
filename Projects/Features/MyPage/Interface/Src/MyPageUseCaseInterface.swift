//
//  MyPageUseCaseInterface.swift
//  ChatInterface
//
//  Created by SeungMin on 1/16/24.
//

import Foundation
import RxSwift
import SignUpInterface
import AuthInterface

public protocol MyPageUseCaseInterface {
  func fetchUser() -> Single<User>
  func fetchUserContacts() -> Single<Int>
  func updateUserContact() -> Single<Int>
  func fetchAlarmSetting() -> AlarmSetting
  func saveAlarmSetting(_ alarmSetting: AlarmSetting) -> Completable
  func updateLocation(_ location: LocationReq) -> Single<Void>
}
