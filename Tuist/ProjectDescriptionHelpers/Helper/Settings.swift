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
    .manualCodeSigning()
    .bitcodeEnabled(false)
    .otherLinkerFlags(["-ObjC"])

  static let appInfoPlist: [String: Plist.Value] = [
      "UIMainStoryboardFile": "",
      "UILaunchStoryboardName": "LaunchScreen",
  ]
}
