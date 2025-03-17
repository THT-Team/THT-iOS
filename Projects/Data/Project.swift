//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Hoo's MacBookPro on 12/3/23.
//

import ProjectDescription
import ProjectDescriptionHelpers
import MyPlugin

let firebase: ProjectDescription.SettingsDictionary = [
  "HEADER_SEARCH_PATHS": [
    "$(inherited)",
    "$(SRCROOT)/../../Tuist/Dependencies/SwiftPackageManager/.build/checkouts/GTMAppAuth/GTMAppAuth/Sources/Public/GTMAppAuth",
    "$(SRCROOT)/../../Tuist/Dependencies/SwiftPackageManager/.build/checkouts/gtm-session-fetcher/Sources/Core/Public"
  ],
  "OTHER_LDFLAGS" : "-ObjC"
]
let project = Project.makeModule(
  name: Feature.Data.rawValue,
  dependencies: [
    .domain,
    .module(implementation: .Network, pathName: .Modules(.Network)),
    .SPM.KakaoSDKAuth,
    .SPM.KakaoSDKUser,
    .SPM.KakaoSDKCommon,
    .SPM.FirebaseStorage,
    .SPM.SwiftStomp,
    .SPM.RealmSwift,
  ],
  product: .staticFramework
)
