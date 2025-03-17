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
        .domain
			]
		),
		.feature(
			implementation: .MyPage,
			dependencies: [
				.feature(interface: .MyPage),
        .dsKit
			]
		),
    .feature(
      demo: .MyPage,
      dependencies: [
        .data,
        .feature(implementation: .SignUp),
        .feature(implementation: .MyPage),
        .feature(implementation: .Auth),
      ]
    )
	]
)
