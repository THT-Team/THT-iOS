//
//  project.swift
//  ProjectDescriptionHelpers
//
//  Created by Kanghos on 2024/01/14.
//

import ProjectDescription
import ProjectDescriptionHelpers
import MyPlugin

let project = Project(
  name: Feature.Domain.rawValue,
  targets: [
    .makeFramework(
      name: Feature.Domain.rawValue,
      sources: ["src/**"],
      dependencies: [
        .core
      ],
      product: .staticFramework
    )
  ]
)
