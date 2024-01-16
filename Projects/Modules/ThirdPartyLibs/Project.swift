//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Hoo's MacBookPro on 12/3/23.
//

import ProjectDescription
import ProjectDescriptionHelpers
import MyPlugin

let project = Project.dynamicFramework(
	name: Feature.ThirdPartyLibs.rawValue,
	dependencies: [
//		.external(.SnapKit),
		.external(.Moya),
		.external(.RxMoya),
//		.external(.Then),
		//		.external(.Starscream),
		.external(.RxSwift),
		.external(.RxCocoa),
//		.external(.RxKeyboard),
//		.external(.Kingfisher),
//		.external(.Lottie),
		//		.external(.Fierbase),
//		.external(.RxGesture),
		.external(.RxDataSources)
	]
)

