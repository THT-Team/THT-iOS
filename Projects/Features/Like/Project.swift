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
	name: Feature.Like.rawValue,
	targets: [
		.feature(
			interface: .Like,
			dependencies: [
				.core,
			]
		),
		.feature(
			implementation: .Like,
			dependencies: [
				.feature(interface: .Like),
				.feature(interface: .Auth),
			]
		),
    .feature(
      demo: .Like,
      dependencies: [
        .feature(implementation: .Like)
      ]
    )
	]
)
