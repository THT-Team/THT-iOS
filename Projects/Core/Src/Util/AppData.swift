//
//  AppData.swift
//  Core
//
//  Created by Kanghos on 2024/03/02.
//

import Foundation

public struct AppData {
  private enum Key: String {
    case accessToken
    case phoneNumber
    case accessTokenExpiredIn
  }
  public struct Auth {
    @Storage<String>(key: Key.accessToken.rawValue, defaultValue: "")
    public static var accessToken

    @Storage<Int>(key: Key.accessTokenExpiredIn.rawValue, defaultValue: 0)
    public static var accessTokenExpiredIn

    public static var needAuth: Bool {
      accessToken.isEmpty
    }
  }

  public struct User {
    @Storage<String>(key: Key.phoneNumber.rawValue, defaultValue: "")
    public static var phoneNumber
  }
}
