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
  func loginSNS(_ request: UserSNSLoginRequest) -> Single<Void>
  func saveSNSType(type snsTYpe: SNSType, snsUUID: String?)
  func saveDeviceKey(_ deviceKey: String)
  func savePhoneNumber(_ phoneNumber: String)
  func fetchPhoneNumber() -> String?
  func needAuth() -> Bool
  func updateDeviceToken() -> Single<Void>

  func auth(_ snsType: SNSType) -> Single<SNSUserInfo>
  func handleLogin(snsUserInfo: SNSUserInfo) -> Single<AuthNavigation>
  func authenticate(userInfo: SNSUserInfo) -> Single<AuthResult>
  func processResult(_ result: AuthResult) -> Single<AuthNavigation>
}
