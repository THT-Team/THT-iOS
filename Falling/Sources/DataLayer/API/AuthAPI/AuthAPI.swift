//
//  AuthAPI.swift
//  Falling
//
//  Created by Kanghos on 2023/08/01.
//

import Foundation
import RxSwift
import RxMoya
import Moya

final class AuthAPI: Networkable {
  static let moya = makeProvider()
  typealias Target = AuthTarget

   static func signUpRequest(request: SignUpRequest) -> Single<SignUpResponse> {
     return moya.rx
       .request(.signup(request: request))
       .map(SignUpResponse.self)
  }

  static func certificate(phoneNumber: String) -> Single<CertificateResponse> {
    return moya.rx
      .request(.certificate(phoneNumber))
      .map(CertificateResponse.self)
  }

  static func login(request: LoginRequest) -> Single<SignUpResponse> {
    return moya.rx
      .request(.login(request: request))
      .map(SignUpResponse.self)
  }

	static func sendPhoneValidationCode(phoneNumber: String) -> Single<PhoneValidationResponse> {
		return moya.rx
			.request(.phoneValidationCodeSend(phoneNumber: phoneNumber))
			.map(PhoneValidationResponse.self)
	}
	
}
