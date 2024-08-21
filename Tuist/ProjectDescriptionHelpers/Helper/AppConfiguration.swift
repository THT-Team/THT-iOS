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
  static let debug: Self = .debug(name: .debug, xcconfig: XCConfig.Application.app(.debug))
  static let release: Self = .release(name: .release, xcconfig: XCConfig.Application.app(.release))
}
