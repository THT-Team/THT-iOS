//
//  AuthRepository.swift
//  Data
//
//  Created by Kanghos on 6/3/24.
//

import Foundation

import Networks

import RxSwift
import RxMoya
import Moya

import Core
import Domain

public class AuthRepository: ProviderProtocol {
  public typealias Target = AuthTarget
  public var provider: Moya.MoyaProvider<AuthTarget>


  public init(_ environment: RepositoryEnvironment) {
    switch environment {
    case .debug:
      self.provider = Self.makeStubProvider()
    case .release:
      self.provider = Self.makeProvider()
    }
  }
}



extension AuthRepository: AuthRepositoryInterface {

  public func checkUserExist(phoneNumber: String) -> RxSwift.Single<UserSignUpInfoRes> {
    request(type: UserSignUpInfoRes.self, target: .checkExistence(phoneNumber: phoneNumber))
  }

  public func certificate(phoneNumber: String) -> Single<Int> {
    return .just(123456)
  }
}

