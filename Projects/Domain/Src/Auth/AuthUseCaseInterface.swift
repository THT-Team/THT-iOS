//
//  AuthUseCaseInterface.swift
//  AuthInterface
//
//  Created by Kanghos on 5/8/24.
//

import Foundation

import RxSwift

public protocol AuthUseCaseInterface {
  func certificate(phoneNumber: String) -> Single<Int>
  func checkUserExists(phoneNumber: String) -> Single<UserSignUpInfoRes>
  func login() -> Single<Void>
  func savePhoneNumber(_ phoneNumber: String)
  func fetchPhoneNumber() -> String?
//  func updateDeviceToken() -> Single<Void>

  func authenticate(_ type: AuthType) -> Single<AuthNavigation> 
}
