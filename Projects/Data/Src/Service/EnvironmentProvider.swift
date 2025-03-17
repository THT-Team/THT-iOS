//
//  EnvironmentProvider.swift
//  Data
//
//  Created by Kanghos on 3/5/25.
//  Copyright © 2025 THT. All rights reserved.
//

import Foundation
import Domain

import Moya
import Alamofire

public class ServiceProvider {
  private let _environemnt: AppEnvironment

  public lazy var environment: RepositoryEnvironment = {
    switch _environemnt {
    case .debug:
      return .debug
    case .release:
      return .release(
        Moya.Session(
          interceptor: AuthenticationInterceptor(
            authenticator: OAuthAuthenticator(tokenService),
            credential: tokenService.getToken()?.toAuthOCredential(),
            refreshWindow: .init(maximumAttempts: 2))))
    }
  }()

  public let tokenService: TokenServiceType
  public let contactService = ContactService()
  public let imageService: ImageServiceType = ImageService()
  public let locationService: LocationServiceType = LocationService()

  public init(_ environment: AppEnvironment) {
    self.tokenService = TokenService(
      tokenStore: UserDefaultTokenStore.shared,
      tokenProvider: DefaultTokenProvider(environment)
    )
    self._environemnt = environment
  }
}
