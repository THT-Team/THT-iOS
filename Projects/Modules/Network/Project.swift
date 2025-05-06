//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Hoo's MacBookPro on 12/3/23.
//

import ProjectDescription
import ProjectDescriptionHelpers
import MyPlugin

let project = Project.makeModule(
  name: Feature.Network.rawValue,
  dependencies: [
    .core,
    .SPM.Moya,
    .SPM.RxMoya,
    .SPM.ComposableArchitecture
  ]
)
