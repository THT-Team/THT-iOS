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
	name: Feature.Chat.rawValue,
	targets: [
		.feature(
			interface: .Chat,
			dependencies: [
				.domain,
			]
		),
		.feature(
			implementation: .Chat,
			dependencies: [
        .feature(interface: .ChatRoom),
				.feature(interface: .Chat),
        .dsKit,
			]
		),
    .feature(
      demo: .Chat,
      dependencies: [
        .feature(implementation: .Chat),
        .data
      ]
    )
	]
)

