//
//  TFIntercepter.swift
//  Data
//
//  Created by Kanghos on 6/5/24.
//

import Foundation
import Alamofire
import RxSwift
import AuthInterface
import Core
import Domain

final class OAuthAuthenticator: Authenticator {
  private let refresher: TokenRefresher
  private let tokenStore: TokenStore

  public init(refresher: TokenRefresher, tokenStore: TokenStore) {
    self.refresher = refresher
    self.tokenStore = tokenStore
  }

  func apply(_ credential: OAuthCredential, to urlRequest: inout URLRequest) {

  }

  func refresh(_ credential: OAuthCredential,
               for session: Session,
               completion: @escaping (Result<OAuthCredential, Error>) -> Void) {


    // Refresh the credential using the refresh token...then call completion with the new credential.
    //
    // The new credential will automatically be stored within the `AuthenticationInterceptor`. Future requests will
    // be authenticated using the `apply(_:to:)` method using the new credential.

    TFLogger.dataLogger.notice("try refresing token!!")

    Task {
      do {
        let refreshToken = try await refresher.refresh(credential.toToken())
        tokenStore.saveToken(token: refreshToken)
        completion(.success(refreshToken.toAuthOCredential()))
      } catch {
        completion(.failure(error))
      }
    }
  }

  func didRequest(_ urlRequest: URLRequest,
                  with response: HTTPURLResponse,
                  failDueToAuthenticationError error: Error) -> Bool {
    // If authentication server CANNOT invalidate credentials, return `false`

    // If authentication server CAN invalidate credentials, then inspect the response matching against what the
    // authentication server returns as an authentication failure. This is generally a 401 along with a custom
    // header value.
    // return response.statusCode == 401
    return response.statusCode == 401
  }

  func isRequest(_ urlRequest: URLRequest, authenticatedWith credential: OAuthCredential) -> Bool {
    // If authentication server CANNOT invalidate credentials, return `true`

    // If authentication server CAN invalidate credentials, then compare the "Authorization" header value in the
    // `URLRequest` against the Bearer token generated with the access token of the `Credential`.
    let bearerToken = HTTPHeader.authorization(bearerToken: credential.accessToken).value
    let header = urlRequest.headers["Authorization"]

    let isSame = header == bearerToken
    print("it is same: \(isSame)")
    return isSame
  }
}
