//
//  SocailRepository.swift
//  Data
//
//  Created by Kanghos on 2/15/25.
//  Copyright © 2025 THT. All rights reserved.
//

import Foundation
import AuthenticationServices

import Domain

import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser

import Core

import RxSwift

public final class SocialLoginRepository: SocialLoginRepositoryInterface {
  private let appleService = AppleLogincService()
  public init() { }
  public func kakaoLogin() -> Single<SNSUserInfo> {
      .create { observer in
        if (UserApi.isKakaoTalkLoginAvailable()) {
          UserApi.shared.loginWithKakaoTalk { token, error in
            if let error {
              return observer(.failure(error))
            }

            guard let _ = token else {
              return observer(.failure(AuthError.invalidSNSUser))
            }
            UserApi.shared.me { user, error in
              if let error {
                observer(.failure(error))
              }
              guard
                let user,
                let id = user.id,
                let phoneNumber = user.kakaoAccount?.phoneNumber?.sanitizedPhoneNumber(),
                let email = user.kakaoAccount?.email
              else {
                return observer(.failure(AuthError.invalidSNSUser))
              }
              return observer(.success(
                SNSUserInfo(snsType: .kakao, id: String(id), email: email, phoneNumber: phoneNumber)
              ))
            }
          }
        } else {
          observer(.failure(AuthError.canNotOpenSNSURL))
        }
        return Disposables.create { }
      }
  }

}

// MARK: Apple

extension SocialLoginRepository {

  public func appleLogin() -> Single<SNSUserInfo> {
    let id = UserDefaultRepository.shared.fetch(for: .appleID, type: String.self)
    appleService.appleLogin(id: id)

    return appleService.publisher
  }
}

final class AppleLogincService: NSObject {

  override init() {
    super.init()
  }

  private let _publisher = RxSwift.PublishSubject<SNSUserInfo>()

  public var publisher: RxSwift.Single<SNSUserInfo> {
    _publisher.asSingle()
      .debug()
  }

  func appleLogin(id: String?) {
    if let id {
      return checkNeedSignUp(id: id)
    }
    return signUp()
  }

  func signUp() {
    let request = ASAuthorizationAppleIDProvider().createRequest()
    request.requestedScopes = [.email, .fullName]

    let controller = ASAuthorizationController(authorizationRequests: [request])
    controller.delegate = self

    controller.performRequests()
  }

  func checkNeedSignUp(id: String) {
    ASAuthorizationAppleIDProvider().getCredentialState(
      forUserID: id) { [weak self] credentailState, error in
        if let error {
          self?._publisher.onError(AuthError.custom(error.localizedDescription))
          self?._publisher.onCompleted()
          return
        }
        switch credentailState {
        case .revoked, .notFound:
          self?.signUp()
        case .authorized:
          self?.signUp()
        case .transferred:
          fatalError("Appple ID Transffered")
        @unknown default:
          break
        }
      }
  }
}

extension AppleLogincService: ASAuthorizationControllerDelegate {

  public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: any Error) {
    _publisher.onError(error)
    _publisher.onCompleted()
  }

  public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
      _publisher.onError(AuthError.custom("Invalid Apple Credentail"))
      _publisher.onCompleted()
      return
    }

    guard let idTokenData = credential.identityToken,
          let idToken = String(data: idTokenData, encoding: .utf8) else {
      _publisher.onError(AuthError.custom("Invalid idToken"))
      _publisher.onCompleted()
      return
    }

    // 6자리 코드
    guard let authCodeData = credential.authorizationCode,
          let authCode = String(data: authCodeData, encoding: .utf8) else {
      _publisher.onError(AuthError.custom("Invalid authCode"))
      _publisher.onCompleted()
      return
    }

    TFLogger.dataLogger.log("idToken: \(idToken)")
    TFLogger.dataLogger.log("authCode: \(authCode)")

    let user = credential.user // UUID
    let fullName = (credential.fullName?.givenName ?? "") + (credential.fullName?.familyName ?? "")
    let email = credential.email ?? ""

    TFLogger.dataLogger.log("UUID: \(user)")
    TFLogger.dataLogger.log("name: \(fullName)")
    TFLogger.dataLogger.log("email: \(email)")
    UserDefaultRepository.shared.save(user, key: .appleID)

    _publisher.onNext(SNSUserInfo(snsType: .apple, id: user, email: email, phoneNumber: ""))
    _publisher.onCompleted()
  }
}

