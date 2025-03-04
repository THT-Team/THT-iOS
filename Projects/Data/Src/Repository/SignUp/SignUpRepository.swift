//
//  SignUpRepository.swift
//  Data
//
//  Created by kangho lee on 5/1/24.
//

import Foundation

import Networks

import RxSwift
import RxMoya
import Moya

import Domain

public typealias SignUpRepository = BaseRepository<SignUpTarget>

extension SignUpRepository: SignUpRepositoryInterface {

  public func checkNickname(nickname: String) -> RxSwift.Single<Bool> {
    request(type: UserNicknameValidRes.self, target: .checkNickname(nickname: nickname))
      .map { $0.isDuplicate }
  }

  public func fetchAgreements() -> Single<Agreement> {
    request(type: Agreement.self, target: .agreement)
  }
}
