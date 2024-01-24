//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Hoo's MacBookPro on 12/3/23.
//

import ProjectDescription
import ProjectDescriptionHelpers
import MyPlugin

let project = Project(
	name: Feature.MyPage.rawValue,
	targets: [
		.feature(
			interface: .MyPage,
			dependencies: [
				.core,
			]
		),
		.feature(
			implementation: .MyPage,
			dependencies: [
				.feature(interface: .MyPage),
				.feature(interface: .Auth),
        .dsKit
			]
		),
    .feature(
      demo: .MyPage,
      dependencies: [
        .feature(implementation: .MyPage)
      ]
    )
	]
)
