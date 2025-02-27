//
//  LocalRepositoryInterface.swift
//  Core
//
//  Created by Kanghos on 7/3/24.
//

import Foundation

public enum PersistentKey: String, CaseIterable {
  case marketAgreement = "marketing_agreement"
  case alarmSetting = "alarm_setting"
  case accessToken = "access_token"
  case userInfo = "user_info"
  case phoneNumber = "phone_number"
  case pendingUser = "pending_user"
  case snsType = "sns_type"
  case deviceKey = "device_key"
  case snsUUID = "sns_uuid"
  case sign_up_info
  case token = "Token"
  case currentUUID = "current_uuid"
  case appleID = "appleID"
}

public protocol KeyValueStorageInterface {
  func remove(key: PersistentKey)
  func save<T>(_ value: T, key: PersistentKey)
  func fetch<T>(for key: PersistentKey, type: T.Type) -> T?
}

public protocol ModelStorageInterface {
  func remove(key: PersistentKey)
  @discardableResult
  func saveModel<T: Encodable>(_ model: T, key: PersistentKey) -> Bool
  func fetchModel<T: Decodable>(for key: PersistentKey, type: T.Type) -> T?
}

public protocol PersistentRepositoryInterface: KeyValueStorageInterface & ModelStorageInterface { }
