//
//  AuthLaunchCoordinating.swift
//  AuthInterface
//
//  Created by Kanghos on 6/4/24.
//

import Foundation
import Core

public protocol LaunchCoordinatingDelegate: AnyObject {
  func finishFlow(_ coordinator: Coordinator, _ action: LaunchAction)
}

public enum LaunchAction {
  case needAuth
  case toMain
}

public protocol AuthLaunchCoordinating: Coordinator {
  var delegate: LaunchCoordinatingDelegate? { get set }
  
  func launchFlow()
}
