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

  public init() { }

  public func build() -> AuthCoordinating {
    let rootViewController = ProgressNavigationViewControllable()
    let coordinator = AuthCoordinator(viewControllable: rootViewController)

    return coordinator
  }
}

public extension UIApplicationDelegate {
  // TODO: Configuation에 등록하기
  func registerKakaoSDK(key: String) {
    KakaoSDK.initSDK(appKey: key, loggingEnable: true)
  }
}
