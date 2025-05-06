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
  case ChatRoom = "ChatRoom"
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
	case Kingfisher
	case Lottie
	case Moya
	case RxMoya
	case Fierbase
	case RxGesture
  case FirebaseMessaging
  case FirebaseStorage
  case ComposableArchitecture

  // MARK: OAuth
  case KakaoSDKAuth
  case KakaoSDKUser
  case KakaoSDKCommon

//  case GoogleSignIn
}

public extension TargetDependency {
  enum SPM {
    public static let RxSwfit = TargetDependency.external(name: "RxSwift")
    public static let RxCocoa = TargetDependency.external(name: "RxCocoa")
    public static let ReactorKit = TargetDependency.external(name: "ReactorKit")
    public static let SwiftStomp =
    TargetDependency.external(name: "SwiftStomp")
    public static let RealmSwift = TargetDependency.external(name: "RealmSwift")

    public static let KingFisher = TargetDependency.external(name: External.Kingfisher.rawValue)
    public static let Moya  = TargetDependency.external(name: External.Moya.rawValue)
    public static let RxMoya  = TargetDependency.external(name: External.RxMoya.rawValue)
    public static let Then  = TargetDependency.external(name: External.Then.rawValue)
    public static let SnapKit  = TargetDependency.external(name: External.SnapKit.rawValue)
    public static let Lottie = TargetDependency.external(name: External.Lottie.rawValue)

    public static let KakaoSDKAuth = TargetDependency.external(name: External.KakaoSDKAuth.rawValue)
    public static let KakaoSDKUser = TargetDependency.external(name: External.KakaoSDKUser.rawValue)
    public static let KakaoSDKCommon = TargetDependency.external(name: External.KakaoSDKCommon.rawValue)
    public static let RxGesture = TargetDependency.external(name: External.RxGesture.rawValue)

    public static let FirebaseMessaging = TargetDependency.external(name: External.FirebaseMessaging.rawValue)
    public static let FirebaseStorage = TargetDependency.external(name: External.FirebaseStorage.rawValue)
    
    public static let ComposableArchitecture = TargetDependency.external(name: External.ComposableArchitecture.rawValue)
  }

  enum XCFramework {
    public static let NaverThirdPartyLogin = TargetDependency.xcframework(path: .relativeToRoot("Framework/NaverThirdPartyLogin.xcframework"))
    public static let Lottie = TargetDependency.xcframework(path: .relativeToRoot("Framework/Lottie.xcframework"))
    public static let FirebaseStorage = TargetDependency.xcframework(path: .relativeToRoot("Framework/Firebase/FirebaseStorage.xcframework"))
  }

  enum Firebase {
    public static var storage: [TargetDependency] {
      [
        .firebase(name: "FirebaseStorage"),
        .firebase(name: "FirebaseAppCheckInterop"),
        .firebase(name: "FirebaseAuthInterop"),
        .firebase(name: "FirebaseCoreExtension"),
        .firebase(name: "GTMSessionFetcher"),
      ]
    }

    public static var message: [TargetDependency] {
      [
        .firebase(name: "GoogleDataTransport"),
        .firebase(name: "FirebaseMessaging")
      ]
    }
  }

  private static func firebase(name: String) -> TargetDependency {
    .xcframework(path: .relativeToRoot("Framework/Firebase/\(name).xcframework"))
  }
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

  static func feature(testing moduleName: Feature) -> TargetDependency {
    .feature(target: moduleName.rawValue + "Testing", featureName: moduleName.rawValue)
  }

  static func feature(test moduleName: Feature) -> TargetDependency {
    .feature(target: moduleName.rawValue + "Test", featureName: moduleName.rawValue)
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
