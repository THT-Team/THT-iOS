//
//  TFIntercepter.swift
//  Data
//
//  Created by Kanghos on 6/5/24.
//

import Foundation
import Moya
import Alamofire
import RxSwift
import AuthInterface
import Core

final class OAuthAuthenticator: Authenticator {
  private var token: OAuthCredential?
  private let authService: AuthServiceType

  init(authService: AuthServiceType) {
    self.authService = authService
  }

  func apply(_ credential: OAuthCredential, to urlRequest: inout URLRequest) {

    // SignUp 관련 API는 토큰 없이 호출해야함
    if let url = urlRequest.url {
      if !(url.path().contains("users/join") || url.path().contains("users/login/normal") || url.path().contains("users/login/sns")) {
        urlRequest.headers.add(.authorization(bearerToken: credential.accessToken))
      }
    }
  }

  func refresh(_ credential: OAuthCredential,
               for session: Session,
               completion: @escaping (Result<OAuthCredential, Error>) -> Void) {


    // Refresh the credential using the refresh token...then call completion with the new credential.
    //
    // The new credential will automatically be stored within the `AuthenticationInterceptor`. Future requests will
    // be authenticated using the `apply(_:to:)` method using the new credential.
    
    TFLogger.dataLogger.notice("try refresing token!!")

    authService.refreshToken() { result in
      switch result {
      case .success(let refreshedToken):
        completion(.success(refreshedToken.toAuthOCredential()))
      case .failure(let failure):
        completion(.failure(failure))
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
    return urlRequest.headers["Authorization"] == bearerToken
  }
}
