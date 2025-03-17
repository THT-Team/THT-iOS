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
  name: Feature.ThirdPartyLibs.rawValue,
  dependencies: [
    .SPM.RxSwfit,
    .SPM.ReactorKit,
    .SPM.FirebaseMessaging,
  ],

  product: .staticLibrary
  )
