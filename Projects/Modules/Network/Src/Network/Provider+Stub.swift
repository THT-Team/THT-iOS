//
//  Provider+Stub.swift
//  Networks
//
//  Created by Kanghos on 2/20/25.
//  Copyright © 2025 THT. All rights reserved.
//

import Foundation

import Moya

extension ProviderProtocol {
  public static func makeStubProvider(sampleStatusCode: Int = 200) -> MoyaProvider<Target> {
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

  public static func consProvider(
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
}
