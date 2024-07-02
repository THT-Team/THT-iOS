//
//  Dependencies.swift
//  ProjectDescriptionHelpers
//
//  Created by Hoo's MacBookPro on 12/3/23.
//

import ProjectDescription
import ProjectDescriptionHelpers

let spm = SwiftPackageManagerDependencies(
	[
		.remote(url: "https://github.com/SnapKit/SnapKit.git", requirement: .upToNextMajor(from: "5.0.0")),
		.remote(url: "https://github.com/Moya/Moya.git", requirement: .upToNextMajor(from: "15.0.0")),
		.remote(url: "https://github.com/devxoul/Then", requirement: .upToNextMajor(from: "3.0.0")),
		.remote(url: "https://github.com/daltoniam/Starscream.git", requirement: .upToNextMajor(from: "4.0.0")),
		.remote(url: "https://github.com/ReactiveX/RxSwift.git", requirement: .upToNextMajor(from: "6.0.0")),
		.remote(url: "https://github.com/onevcat/Kingfisher.git", requirement: .upToNextMajor(from: "7.0.0")),
		.remote(url: "https://github.com/airbnb/lottie-spm.git", requirement: .upToNextMajor(from: "4.0.0")),
		.remote(url: "https://github.com/firebase/firebase-ios-sdk.git", requirement: .exact("11.0.0")),
		.remote(url: "https://github.com/RxSwiftCommunity/RxGesture.git", requirement: .upToNextMajor(from: "4.0.0")),
    .remote(url: "https://github.com/kakao/kakao-ios-sdk", requirement: .branch("master")),
	]
)

let dependencies = Dependencies(
	swiftPackageManager: spm,
	platforms: [.iOS]
)
