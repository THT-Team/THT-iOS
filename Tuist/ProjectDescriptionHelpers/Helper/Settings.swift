//
//  Settings.swift
//  ProjectDescriptionHelpers
//
//  Created by Kanghos on 8/4/24.
//

import Foundation
import ProjectDescription

public enum AppSettings {
  public static let organizationName: String = "tht"
  public static let deploymentTargets = DeploymentTargets.iOS("17.0")

  public static let baseSetting: SettingsDictionary = .init()
        .merging(signingSetting())
    .bitcodeEnabled(false)
    .otherLinkerFlags(["-ObjC"])

  static let appInfoPlist: [String: Plist.Value] = [
      "UIMainStoryboardFile": "",
      "UILaunchStoryboardName": "LaunchScreen",
  ]
    
  private static func signingSetting() -> SettingsDictionary {
    [
      "DEVELOPMENT_TEAM": "SJDR485DTV",
      "CODE_SIGN_STYLE": "Manual",
      "PROVISIONING_PROFILE_SPECIFIER": "match AppStore com.tht.demo.fallingdemoapp",
      "CODE_SIGN_IDENTITY": "Apple Distribution: Kangho lee (UY52N5ZAAV)"
    ]
  }
}
