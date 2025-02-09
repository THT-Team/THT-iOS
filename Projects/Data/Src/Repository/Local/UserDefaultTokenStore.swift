//
//  UserDefaultTokenStore.swift
//  Data
//
//  Created by Kanghos on 6/3/24.
//

import Foundation

import AuthInterface
import RxSwift
import Domain

public final class UserDefaultTokenStore: TokenStore {
  enum Key {
    static let token = "Token"
  }
  public var cachedToken: Token?

  public static let shared: TokenStore = UserDefaultTokenStore()

  private init () {
    self.cachedToken = try? UserDefaults.standard.getCodableObject(forKey: Key.token, as: Token.self)
  }

  public func saveToken(token: Token) {
    try? UserDefaults.standard.setCodableObject(token, forKey: Key.token)
    cachedToken = token
  }

  public func getToken() -> Token? {
    return cachedToken
  }

  public func clearToken() {
    cachedToken = nil
    UserDefaults.standard.removeObject(forKey: Key.token)
  }
}
