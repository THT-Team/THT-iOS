//
//  AuthLaunchCoordinating.swift
//  AuthInterface
//
//  Created by Kanghos on 6/4/24.
//

import Foundation
import Core

public enum LaunchAction {
  case needAuth
  case toMain
}

public protocol AuthLaunchCoordinating: Coordinator {
  var finishFlow: ((LaunchAction) -> Void)? { get set }

  func launchFlow()
}
