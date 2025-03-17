//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Hoo's MacBookPro on 12/3/23.
//

import ProjectDescription
import ProjectDescriptionHelpers
import MyPlugin

enum ProductName {
    static let releaseApp = "Falling-iOS"
    static let devApp = "Falling_Dev"
    static let unitTest = "iOS_UnitTests"
}

let settings: Settings = .settings(
  base: AppSettings.baseSetting,
  configurations: [.debug, .release],
  defaultSettings: .recommended)

let app: [String: Plist.Value] = [
  "UIMainStoryboardFile": "",
  "UILaunchStoryboardName": "LaunchScreen",

  "UIApplicationSceneManifest": [
    "UIApplicationSupportsMultipleScenes": false,
    "UISceneConfiguations": [
      "UIWindowSceneSessionRoleApplication": [
        [
          "UISceneConfigurationName": "Default Configuration",
          "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
        ]
      ]
    ]
  ]
]

let schemes: [Scheme] = [
  .makeScheme(target: .debug, name: ProductName.devApp),
  .makeReleaseScheme(target: .release, name: ProductName.releaseApp)
  ]

let targets: [Target] = [
    .target(name: ProductName.releaseApp,
            destinations: .iOS,
            product: .app,
            productName: ProductName.releaseApp,
            bundleId: "com.tht.demo.fallingdemoapp",
            deploymentTargets: basicDeployment,
            infoPlist: infoPlistExtension, // .extendingDefault(with: app),
            sources: [.glob("src/**/*.swift",
                            excluding: "src/Dev/**")],
            resources: [.glob(pattern: "Resources/**",
                              excluding: ["Resources/Dev/**"])],
            entitlements: .file(path: .relativeToRoot("Projects/App/Falling-iOS.entitlements")),
            dependencies: [
              .feature,
              .data,
            ]),
    .target(name: ProductName.devApp,
            destinations: .iOS,
            product: .app,
            productName: ProductName.releaseApp,
            bundleId: "com.tht.demo.fallingdemoapp",
            deploymentTargets: basicDeployment,
            infoPlist: .extendingDefault(with: app),
            sources: ["src/**"],
            resources: ["Resources/**"],
            dependencies: [
              .feature,
              .data,
            ]),
]

let project = Project(
  name: "Application",
  organizationName: AppSettings.organizationName,
  settings: settings,
  targets: targets,
  schemes: schemes
  )
