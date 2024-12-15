//
//  SignUpBuilder.swift
//  AuthInterface
//
//  Created by Kanghos on 5/8/24.
//

import UIKit

import SignUpInterface
import AuthInterface

import KakaoSDKCommon
import DSKit
import Core

public final class AuthBuilder: AuthBuildable {
  private let signUpBuilable: SignUpBuildable
  private let inquiryBuildable: InquiryBuildable
  private lazy var authViewFactory: AuthViewFactoryType =
    AuthViewFactory()

  public init(signUpBuilable: SignUpBuildable, inquiryBuildable: InquiryBuildable) {
    self.signUpBuilable = signUpBuilable
    self.inquiryBuildable = inquiryBuildable
  }

  public func build() -> AuthCoordinating {
    let rootViewController = ProgressNavigationViewControllable()
    let coordinator = AuthCoordinator(signUpBuildable: signUpBuilable,
                                      inquiryBuildable: inquiryBuildable,
                                      authViewFactory: authViewFactory,
                                      viewControllable: rootViewController)

    return coordinator
  }
}

public extension UIApplicationDelegate {
  // TODO: Configuation에 등록하기
  func registerKakaoSDK(key: String) {
    KakaoSDK.initSDK(appKey: key, loggingEnable: true)
  }
}
