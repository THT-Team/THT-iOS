//
//  UserDefaultTokenStore.swift
//  Data
//
//  Created by Kanghos on 6/3/24.
//

import Foundation

import AuthInterface
import RxSwift

public final class UserDefaultTokenStore: TokenStore {
  enum Key {
    static let token = "Token"
  }
  public var cachedToken: Token?

  public init () {}

  public func saveToken(token: AuthInterface.Token) {
    cachedToken = token
    try? UserDefaults.standard.setCodableObject(token, forKey: Key.token)
  }

  public func getToken() -> Token? {
    try? UserDefaults.standard.getCodableObject(forKey: Key.token, as: AuthInterface.Token.self)
  }

  public func clearToken() {
    cachedToken = nil
    UserDefaults.standard.removeObject(forKey: Key.token)
  }
}
