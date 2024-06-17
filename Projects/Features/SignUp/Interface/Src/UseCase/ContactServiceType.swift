//
//  ContactServiceType.swift
//  SignUpInterface
//
//  Created by Kanghos on 5/14/24.
//

import Foundation

import RxSwift

import AuthInterface

public protocol ContactServiceType {
  func fetchContact() -> Single<[ContactType]>
}
