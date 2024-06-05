//
//  TokenStore.swift
//  AuthInterface
//
//  Created by Kanghos on 5/8/24.
//

import Foundation

import RxSwift
public protocol TokenStore {
  var cachedToken: Token? { get set }
  func saveToken(token: Token)
  func getToken() -> Single<Token>
  func clearToken()
}
