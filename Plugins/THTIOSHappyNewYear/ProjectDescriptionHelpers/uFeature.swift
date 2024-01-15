//
//  uFeature.swift
//  MyPlugin
//
//  Created by Kanghos on 2023/11/19.
//

import Foundation
import ProjectDescription

public enum Feature: String {
	// MARK: - Application
	case App = "App"
	
	// MARK: - Features
	case Like = "Like"
	case Auth = "Auth"
	case SignUp = "SignUp"
	case Falling = "Falling"
	case Chat = "Chat"
	case MyPage = "MyPage"
	
	// MARK: - Modules
	case Network = "Networks"
	case Data = "Data"
	case Core = "Core"
  case Domain = "Domain"
  case ThirdPartyLibs
  case DesignSystem = "DSKit"
}

public enum ModulePath {
  case App
  case Core
  case Data
  case Domain
  case Features
  case Modules(ModuleName)

  public enum ModuleName: String {
    case Network
    case ThirdPartyLibs
    case DesignSystem
  }

  var name: String {
    switch self {
    case .App:
      return "App"
    case .Core:
      return "Core"
    case .Data:
      return "Data"
    case .Domain:
      return "Domain"
    case .Features:
      return "Features"
    case .Modules(let moduleName):
      return "Modules/\(moduleName.rawValue)"
    }
  }
}

public enum External: String {
  case RxSwift
  case RxCocoa
  case SnapKit
	case Then
	case Starscream
	case RxKeyboard
	case Kingfisher
	case Lottie
	case Moya
	case RxMoya
	case Fierbase
	case RxGesture
	case RxDataSources
}

public extension TargetDependency {

  // MARK: Feature
  static var feature: Self {
    .project(target: "Feature", path: .relativeToRoot("Projects/Features"))
  }

  private static func feature(target: String, featureName: String) -> ProjectDescription.TargetDependency {
    .project(target: target, path: .relativeToRoot("Projects/Features/" + featureName))
  }

  private static func feature(interface moduleName: String) -> ProjectDescription.TargetDependency {
    .feature(target: moduleName + "Interface", featureName: moduleName)
  }

  private static func feature(implementation moduleName: String) -> ProjectDescription.TargetDependency {
    .feature(target: moduleName, featureName: moduleName)
  }

  static func feature(interface moduleName: Feature) -> ProjectDescription.TargetDependency {
    .feature(interface: moduleName.rawValue)
  }

  static func feature(implementation moduleName: Feature) -> ProjectDescription.TargetDependency {
    .feature(implementation: moduleName.rawValue)
  }

  // MARK: Module

  private static func module(target: String, pathName: String) -> TargetDependency {
    .project(target: target, path: .relativeToRoot("Projects/\(pathName)/"))
  }
  static func module(implementation moduleName: Feature, pathName: ModulePath) -> TargetDependency {
    .module(target: moduleName.rawValue, pathName: pathName.name)
  }

  static func external(_ module: External) -> ProjectDescription.TargetDependency {
    .external(name: module.rawValue)
  }

  static var core: ProjectDescription.TargetDependency {
    .module(implementation: .Core, pathName: .Core)
  }
	
	static var data: ProjectDescription.TargetDependency {
		.module(implementation: .Data, pathName: .Data)
	}

  static var domain: ProjectDescription.TargetDependency {
    .module(implementation: .Domain, pathName: .Domain)
  }
  static var dsKit: TargetDependency {
    .module(implementation: .DesignSystem, pathName: .Modules(.DesignSystem))
  }
}
