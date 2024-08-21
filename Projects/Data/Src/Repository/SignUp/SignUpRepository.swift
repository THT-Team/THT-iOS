//
//  SignUpRepository.swift
//  Data
//
//  Created by kangho lee on 5/1/24.
//

import Foundation

import SignUpInterface
import AuthInterface
import Networks

import RxSwift
import RxMoya
import Moya

import Core

public final class SignUpRepository: ProviderProtocol {

  public typealias Target = SignUpTarget
  public var provider: MoyaProvider<Target>

  public init() {
    self.provider = Self.makeStubProvider()
  }
}

extension SignUpRepository: SignUpRepositoryInterface {

  public func checkNickname(nickname: String) -> RxSwift.Single<Bool> {
    request(type: UserNicknameValidRes.self, target: .checkNickname(nickname: nickname))
      .map { $0.isDuplicate }
  }

  public func fetchAgreements() -> Single<Agreement> {
    request(type: Agreement.self, target: .agreement)
  }
}
