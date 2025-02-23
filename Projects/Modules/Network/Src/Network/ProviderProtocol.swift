//
//  ProviderProtocol.swift
//  Falling
//
//  Created by Kanghos on 2023/09/14.
//

import Foundation

import Moya
import RxMoya
import RxSwift

import Alamofire
import Core

public protocol ProviderProtocol: AnyObject, Networkable {
  var provider: MoyaProvider<Target> { get set }
}

extension ProviderProtocol {

  public func request<D: Decodable>(type: D.Type, target: Target) -> Single<D> {
    provider.rx.request(target)
      .map(type, using: .customDeocder)
      .catch {
        let apiError = ErrorMaper.map($0)
        if case APIError.tokenRefreshFailed = apiError {
          NotificationCenter.default.post(Notification(name: .needAuthLogout))
        }
        return .error(apiError)
      }
  }

  public func requestWithNoContent(target: Target) -> Single<Void> {
    provider.rx.request(target)
      .map { _ in }
      .catch {
        let apiError = ErrorMaper.map($0)
        if case APIError.tokenRefreshFailed = apiError {
          NotificationCenter.default.post(Notification(name: .needAuthLogout))
        }
        return .error(apiError)
      }
  }
}
