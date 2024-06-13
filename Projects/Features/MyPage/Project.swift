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
        .feature(interface: .SignUp),
			]
		),
		.feature(
			implementation: .MyPage,
			dependencies: [
				.feature(interface: .MyPage),
				.feature(interface: .Auth),
        .feature(interface: .SignUp),
        .dsKit
			]
		),
    .feature(
      demo: .MyPage,
      dependencies: [
        .data,
        .feature(implementation: .SignUp),
        .feature(implementation: .MyPage)
      ]
    )
	]
)
