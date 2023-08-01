//
//  AppData.swift
//  Falling
//
//  Created by Kanghos on 2023/08/01.
//

import Foundation

struct AppData {
  private enum Key: String {
    case access_token
    case enable_auto_login
  }

  @DataStorage(key: Key.access_token.rawValue, defaultValue: "")
  static var accessToken: String

  @DataStorage(key: Key.enable_auto_login.rawValue, defaultValue: false)
  static var isEnableAutoLogin: Bool
}
