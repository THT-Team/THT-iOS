// swift-tools-version: 5.9
import PackageDescription

#if TUIST
import ProjectDescriptionHelpers
import ProjectDescription

let packageSettings = PackageSettings(
  productTypes: [
    "RxCocoa": .framework,
//    "RxSwift": .framework,
    "RxGesture": .framework,
    "SnapKit": .framework,
    "Kingfisher": .framework,
    "Then": .framework,
    "RxRelay": .framework,
    "RxCocoaRuntime": .framework,
    "Lottie": .framework,
    "ReactorKit": .framework,
    "SwiftStomp": .framework,
    "RealmSwift": .framework,
  ]
)
#endif

let package = Package(
  name: "App",
  platforms: [.iOS(.v16)],
  dependencies: [
    .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "6.7.1")),
    .package(url: "https://github.com/RxSwiftCommunity/RxGesture.git", .upToNextMajor(from: "4.0.0")),
    .package(url: "https://github.com/SnapKit/SnapKit.git", .upToNextMajor(from: "5.0.0")),
    .package(url: "https://github.com/devxoul/Then", .upToNextMajor(from: "3.0.0")),
    .package(url: "https://github.com/onevcat/Kingfisher.git", .upToNextMajor(from: "7.0.0")),
    .package(url: "https://github.com/Moya/Moya.git", .upToNextMajor(from: "15.0.0")),
    .package(url: "https://github.com/kakao/kakao-ios-sdk", branch: "master"),
    .package(url: "https://github.com/Alamofire/Alamofire", from: "5.0.0"),
    .package(url: "https://github.com/firebase/firebase-ios-sdk.git", .upToNextMajor(from: "11.0.0")),
    .package(url: "https://github.com/airbnb/lottie-spm.git", .upToNextMajor(from: "4.0.0")),
    .package(url: "https://github.com/ReactorKit/ReactorKit.git",
      .upToNextMajor(from: "3.2.0")),
    .package(url: "https://github.com/Romixery/SwiftStomp.git",
      .upToNextMajor(from: "1.2.1")),
    .package(url: "https://github.com/realm/realm-swift", .upToNextMajor(from: "20.0.1")),
  ]
)
