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
	name: Feature.Falling.rawValue,
	targets: [
		.feature(
			interface: .Falling,
			dependencies: [
				.core,
			]
		),
		.feature(
			implementation: .Falling,
			dependencies: [
				.feature(interface: .Falling),
				.feature(interface: .Auth)
			]
		)
	]
)

