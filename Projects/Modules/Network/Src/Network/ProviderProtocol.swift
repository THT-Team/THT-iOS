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

public protocol ProviderProtocol: AnyObject, Networkable {
  var provider: MoyaProvider<Target> { get set }
}

public extension ProviderProtocol {
  static func makeStubProvider(sampleStatusCode: Int = 200) -> MoyaProvider<Target> {
    let endPointClosure = { (target: Target) -> Endpoint in
      let sampleResponseClosure: () -> EndpointSampleResponse = {
        EndpointSampleResponse.networkResponse(sampleStatusCode, target.sampleData)
      }

      return Endpoint(
        url: URL(target: target).absoluteString,
        sampleResponseClosure: sampleResponseClosure,
        method: target.method,
        task: target.task,
        httpHeaderFields: target.headers
      )
    }

    return MoyaProvider<Target>(
      endpointClosure: endPointClosure,
      stubClosure: MoyaProvider.immediatelyStub(_:)
    )
  }

  static func consProvider(
    _ isStub: Bool = false,
    _ sampleStatusCode: Int = 200,
    _ customendpointClosure: ((Target) -> Endpoint)? = nil) -> MoyaProvider<Target> {
      if isStub == false {
        return makeProvider()
      } else {
        let endPointClosure = { (target: Target) -> Endpoint in
          let sampleResponseClosure: () -> EndpointSampleResponse = {
            EndpointSampleResponse.networkResponse(sampleStatusCode, target.sampleData)
          }

          return Endpoint(
            url: URL(target: target).absoluteString,
            sampleResponseClosure: sampleResponseClosure,
            method: target.method,
            task: target.task,
            httpHeaderFields: target.headers
          )
        }
        return MoyaProvider<Target>(
          endpointClosure: customendpointClosure ?? endPointClosure,
          stubClosure: MoyaProvider.immediatelyStub(_:)
        )
      }
    }

  func request<D: Decodable>(type: D.Type, target: Target) -> Single<D> {
    provider.rx.request(target)
      .map(type)
      .catch { error in
        if let error = error as? MoyaError {
          print(error.localizedDescription)
          return .error(error)
        }
        if let error = error as? DecodingError {
          print(error.localizedDescription)
          return .error(error)
        }
        print(error.localizedDescription)
        return .error(error)
      }
  }

  func request<D: Decodable>(target: Target, completion: @escaping (Result<D, Error>) -> Void) {
    provider.request(target) { result in
      switch result {
      case let .success(response):
        let decoder = JSONDecoder()
        do {
          let model = try decoder.decode(D.self, from: response.data)
          completion(.success(model))
        } catch {
          completion(.failure(error))
        }
      case let .failure(error):
        completion(.failure(error))
      }
    }
  }

  func requestWithNoContent(target: Target) -> Single<Void> {
    provider.rx.request(target)
      .map { _ in }
  }
}
