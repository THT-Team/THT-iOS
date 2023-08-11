//
//  AppData.swift
//  Falling
//
//  Created by Kanghos on 2023/08/01.
//

import Foundation

struct AppData {
  private enum Key: String {
    case enable_auto_login
    case access_token
  }

  @DataStorage(key: Key.enable_auto_login.rawValue, defaultValue: false)
  static var isEnableAutoLogin: Bool

  static var accessToken: String? {
    return "aa"
//    Keychain.shared.get(Key.access_token.rawValue)
  }
}
