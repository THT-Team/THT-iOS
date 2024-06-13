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
		name: Feature.SignUp.rawValue,
		targets: [
				.feature(
					interface: .SignUp,
						dependencies: [
							.core,
              .feature(interface: .Auth)
						]
				),
				.feature(
						implementation: .SignUp,
						dependencies: [
							.feature(interface: .SignUp),
							.feature(interface: .Auth),
              .dsKit
						]
				),
        .feature(
          demo: .SignUp,
          dependencies: [
            .feature(implementation: .SignUp),
            .data
          ]
        )
		]
)

