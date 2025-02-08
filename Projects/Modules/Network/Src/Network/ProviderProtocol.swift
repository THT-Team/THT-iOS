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

extension ParseStrategy where Self == Date.ISO8601FormatStyle {
  static var iso8601OptionalFractionalSeconds: Self { .init(includingFractionalSeconds: true)
  }
}

extension JSONDecoder.DateDecodingStrategy {
  static let iso8601withOptionalFractionalSeconds = custom {
    var rawString = try $0.singleValueContainer().decode(String.self)
    if !rawString.hasSuffix("Z") {
      rawString.append(contentsOf: "Z")
    }

    do {
      return try .init(rawString, strategy: .iso8601OptionalFractionalSeconds)
    } catch {
      return try .init(rawString, strategy: .iso8601)
    }
  }
}

extension JSONDecoder {
  static let customDeocder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601withOptionalFractionalSeconds
    return decoder
  }()
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

  static func stubWithSessionProvider(
    _ session: Moya.Session) -> MoyaProvider<Target> {
      let endPointClosure = { (target: Target) -> Endpoint in
        let sampleResponseClosure: () -> EndpointSampleResponse = {
          EndpointSampleResponse.networkResponse(401, target.sampleData)
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
        stubClosure: MoyaProvider.immediatelyStub(_:),
        session: session
      )
    }

  func request<D: Decodable>(type: D.Type, target: Target) -> Single<D> {
    provider.rx.request(target)
      .map(type, using: .customDeocder)
      .catch { .error(ErrorMaper.map($0)) }
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

  func request<D: Decodable>(target: Target) async throws -> D {
    try await withCheckedThrowingContinuation { continuation in
      provider.request(target) { result in
        switch result {
        case let .success(response):
          do {
            let model = try JSONDecoder().decode(D.self, from: response.data)
            continuation.resume(returning: model)
          } catch {
            continuation.resume(throwing: error)
          }
        case let .failure(error):
          continuation.resume(throwing: error)
        }
      }
    }
  }

  func fetchData(completion: @escaping (Result<String, Error>) -> Void) {
      // Some network call
      DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
          completion(.success("Data fetched!"))
      }
  }

  func fetchData() async throws -> String {
    return try await withCheckedThrowingContinuation { continuation in
      fetchData { result in
        switch result {
        case .success(let success):
          continuation.resume(returning: success)
        case .failure(let failure):
          continuation.resume(throwing: failure)
        }
      }
    }
  }

  func requestWithNoContent(target: Target) -> Single<Void> {
    provider.rx.request(target)
      .map { _ in }
      .catch { .error(ErrorMaper.map($0)) }
  }
}

fileprivate struct ErrorMaper {
  static func map(_ error: Error) -> APIError {
    guard
      let moyaError = error as? MoyaError,
      let response = moyaError.response,
      let errorResponse = try? JSONDecoder.customDeocder.decode(ErrorResponse.self, from: response.data)
    else { return APIError.unknown(error) }
    return APIError.serverError(errorResponse)
  }
}
