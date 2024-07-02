//
//  Networkable.swift
//  Falling
//
//  Created by Kanghos on 2023/07/10.
//

import Moya

public protocol Networkable {

  // TargetType을 준수하는 Generic Type
  associatedtype Target: TargetType

  // DIP를 위해 protocol에 provider객체를 만드는 함수 정의
  static func makeProvider() -> MoyaProvider<Target>
}

public extension Networkable {

  static func makeProvider() -> MoyaProvider<Target> {
    let loggerPlugin = NetworkLoggerPlugin()
    return MoyaProvider<Target>(plugins: [loggerPlugin])
  }

  static func makeProvider(session: Session) -> MoyaProvider<Target> {
    let loggerPlugin = NetworkLoggerPlugin()
    return MoyaProvider<Target>(session: session, plugins: [loggerPlugin])
  }

  static var provider: MoyaProvider<Target> {
    makeProvider()
  }
}

