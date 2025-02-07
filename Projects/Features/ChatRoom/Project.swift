//
//  Project.swift
//  AppManifests
//
//  Created by Kanghos on 1/6/25.
//

import ProjectDescription
import ProjectDescriptionHelpers
import MyPlugin

let project = Project(
  name: Feature.ChatRoom.rawValue,
  targets: [
    .feature(
      interface: .ChatRoom,
      dependencies: [
        .domain,
      ]
    ),
    .feature(
      implementation: .ChatRoom,
      dependencies: [
        .feature(interface: .ChatRoom),
        .feature(interface: .Auth),
        .dsKit,
      ]
    ),
    .feature(
      demo: .ChatRoom,
      dependencies: [
        .feature(implementation: .ChatRoom),
        .data
      ]
    )
  ]
)


