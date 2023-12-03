//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Hoo's MacBookPro on 12/3/23.
//

import ProjectDescription
import ProjectDescriptionHelpers
import MyPlugin

let project = Project.dynamicFramework(
	name: Feature.Network.rawValue,
	dependencies: [
		.core
	]
)
