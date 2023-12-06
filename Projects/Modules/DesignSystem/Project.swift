//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Hoo's MacBookPro on 12/3/23.
//

import ProjectDescription
import ProjectDescriptionHelpers
import MyPlugin

let project = Project.designSystem(
  name: Feature.DesignSystem.rawValue,
  dependencies: [],
  infoPlist: .extendingDefault(with: infoPlistExtension(name: Feature.DesignSystem.rawValue))
)
