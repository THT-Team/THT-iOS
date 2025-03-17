//
//  TokenStore.swift
//  AuthInterface
//
//  Created by Kanghos on 5/8/24.
//

import Foundation

import RxSwift

public protocol TokenStore {
  func saveToken(token: Token)
  func getToken() -> Token?
  func clearToken()
}
