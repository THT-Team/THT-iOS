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
				.domain,
			]
		),
		.feature(
			implementation: .Like,
			dependencies: [
        .feature(interface: .ChatRoom),
				.feature(interface: .Like),
        .dsKit,
			]
		),
    .feature(
      demo: .Like,
      dependencies: [
        .data,
        .feature(implementation: .Like),
        .feature(implementation: .ChatRoom)
      ]
    ),
    .unitTest(
      feature: .Like,
      dependencies: [
        .feature(implementation: .Like)
      ]
    )
	]
)
