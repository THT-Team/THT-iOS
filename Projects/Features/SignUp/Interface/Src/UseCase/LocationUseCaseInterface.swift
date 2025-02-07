//
//  LocationUseCaseInterface.swift
//  SignUpInterface
//
//  Created by Kanghos on 6/10/24.
//

import Foundation

import RxSwift

import AuthInterface
import Domain

public protocol LocationUseCaseInterface {
  func fetchLocation() -> Single<LocationReq>
  func fetchLocation(address: String) -> Single<LocationReq>
  func isValid(_ location: LocationReq?) -> Single<Bool>
}
