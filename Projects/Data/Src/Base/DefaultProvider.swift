//
//  DefaultProvider.swift
//  Data
//
//  Created by Kanghos on 6/25/24.
//

import Foundation
import Networks

import Moya
import Alamofire
import AuthInterface

extension ProviderProtocol {
  static func makeStubProvider() -> MoyaProvider<Target> {
    return consProvider(true)
  }
}
