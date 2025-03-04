//
//  SignUpRepositoryInterface.swift
//  SignUpInterface
//
//  Created by kangho lee on 5/1/24.
//

import Foundation

import RxSwift

public protocol SignUpRepositoryInterface {
  func checkNickname(nickname: String) -> Single<Bool>
  func fetchAgreements() -> Single<Agreement>
}
