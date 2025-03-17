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
	name: Feature.Auth.rawValue,
	targets: [
		.feature(
			interface: .Auth,
			dependencies: [
				.domain,
			]
		),
		.feature(
			implementation: .Auth,
			dependencies: [
        .feature(interface: .Auth),
        .feature(interface: .SignUp),
        .dsKit,
			]
		),
    .feature(
      demo: .Auth,
      dependencies: [
        .feature(implementation: .SignUp),
        .feature(implementation: .Auth),
        .data
      ]
    )
	]
)

