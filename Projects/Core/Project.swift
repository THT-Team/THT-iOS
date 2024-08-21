//
//  Project.swift
//  Config
//
//  Created by Kanghos on 2023/11/19.
//

import ProjectDescription
import ProjectDescriptionHelpers
import MyPlugin

let project = Project(
	name: Feature.Core.rawValue,
	targets: [
    .makeFramework(
      name: Feature.Core.rawValue,
      sources: ["src/**"],
      dependencies: [
        .module(implementation: .ThirdPartyLibs, pathName: .Modules(.ThirdPartyLibs)),
      ],
      product: .staticFramework
    )
	]
)
