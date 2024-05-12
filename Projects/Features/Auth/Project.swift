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
				.core,
			]
		),
		.feature(
			implementation: .Auth,
			dependencies: [
				.feature(interface: .Auth),
        .feature(interface: .SignUp),
        .dsKit
			]
		)
	]
)

