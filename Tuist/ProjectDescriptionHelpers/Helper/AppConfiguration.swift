//
//  AppConfiguration.swift
//  AppManifests
//
//  Created by Kanghos on 8/4/24.
//

import Foundation
import ProjectDescription

public enum AppConfiguration: String {
  case debug = "Debug"
  case release = "Release"
  
  public var configurationName: ConfigurationName {
    .configuration(rawValue)
  }
}

public extension ConfigurationName {
  static var debug: Self { AppConfiguration.debug.configurationName }
  static var release: Self { AppConfiguration.release.configurationName }
}

public enum XCConfig { }

public extension XCConfig {
  enum Application {
    public static func app(_ configuration: AppConfiguration) -> Path {
      .relativeToRoot("XCConfig/APP/\(configuration.rawValue).xcconfig")
    }
  }
}

public extension Configuration {
  static let debug: Self = .debug(name: .debug, settings: .provisioning(buildMode: .debug),  xcconfig: XCConfig.Application.app(.debug))
  static let release: Self = .release(name: .release, settings: .provisioning(buildMode: .release), xcconfig: XCConfig.Application.app(.release))
}

extension ProjectDescription.SettingsDictionary {
  enum BuildMode {
    case debug
    case release
    
    var provisioningName: String {
      switch self {
      case .debug:
        return "Development"
      case .release:
        return "AppStore"
      }
    }
  }
  
  static func provisioning(buildMode: BuildMode) -> SettingsDictionary {
    [
      "DEVELOPMENT_TEAM": "SJDR485DTV",
      "CODE_SIGN_STYLE": "Manual",
      "PROVISIONING_PROFILE_SPECIFIER": "match \(buildMode.provisioningName) com.tht.demo.fallingdemoapp",
      "CODE_SIGN_IDENTITY": "Apple Distribution: Kangho lee (UY52N5ZAAV)"
    ]
  }
}
