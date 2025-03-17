//
//  UserDefaultTokenStore.swift
//  Data
//
//  Created by Kanghos on 6/3/24.
//

import Foundation

import RxSwift
import Domain

public final class UserDefaultTokenStore: TokenStore {
  enum Key {
    static let token = "Token"
  }

  public static let shared: TokenStore = UserDefaultTokenStore()

  private init () {
    _ = try? UserDefaults.standard.getCodableObject(forKey: Key.token, as: Token.self)
  }

  public func saveToken(token: Token) {
    try? UserDefaults.standard.setCodableObject(token, forKey: Key.token)
  }

  public func getToken() -> Token? {
    return try? UserDefaults.standard.getCodableObject(forKey: Key.token, as: Token.self)
  }

  public func clearToken() {
    UserDefaults.standard.removeObject(forKey: Key.token)
  }
}
