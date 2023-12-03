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
	name: Feature.Data.rawValue,
	targets: [
		.feature(
			implementation: .Data,
			dependencies: [
				.feature(interface: .Auth),
				.feature(interface: .Like),
				.feature(interface: .Chat),
				.feature(interface: .MyPage),
				.feature(interface: .Falling),
				.feature(interface: .SignUp),
				.module(implementation: .Network, pathName: .Modules(.Network))
			]
		)
	]
)
