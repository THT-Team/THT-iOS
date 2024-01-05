//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Kanghos on 2023/11/26.
//

import ProjectDescription
import ProjectDescriptionHelpers
import MyPlugin

let project = Project(
	name: "Feature",
	targets: [
		.feature(
			dependencies: [
				.feature(implementation: .Like),
				.feature(implementation: .Auth),
				.feature(implementation: .SignUp),
				.feature(implementation: .Falling),
				.feature(implementation: .Chat),
				.feature(implementation: .MyPage),
				.module(implementation: .Data, pathName: .Data)
			]
		)
	]
)
