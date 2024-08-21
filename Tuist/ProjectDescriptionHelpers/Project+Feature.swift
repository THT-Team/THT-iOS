//
//  Project+Feature.swift
//  ProjectDescriptionHelpers
//
//  Created by Kanghos on 8/6/24.
//

import Foundation
import ProjectDescription

public extension Project {
  static func makeFeature(
    name: String,
    packages: [Package],
    product: Product,
    interfaceDependency: [TargetDependency],
    implementDependency: [TargetDependency],
    demoAppDependency: [TargetDependency]
  ) -> Project {

    let interface = Target.target(
      name: name + "Interface",
      destinations: .iOS,
      product: .staticFramework,
      bundleId: rootPackagesName + name + ".interface",
      deploymentTargets: basicDeployment,
      sources: ["Interface/Src/**"],
      dependencies: [interfaceDependency].flatMap { $0 }
    )
    let implements = Target.target(
      name: name,
      destinations: .iOS,
      product: .staticFramework,
      bundleId: rootPackagesName + name,
      deploymentTargets: basicDeployment,
      sources: ["Src/**"],
      dependencies: [
        [.target(name: name + "Interface")],
        implementDependency
      ].flatMap { $0 }
    )

    let app = Target.target(
      name: name + "App",
      destinations: .iOS,
      product: .app,
      bundleId: rootPackagesName + name + ".app",
      deploymentTargets: basicDeployment,
      dependencies: [[.target(name: name)] + demoAppDependency]
        .flatMap { $0 }
    )

    let targets = [interface, implements, app]

    let settings: Settings = .settings(
      base: .init()
        .manualCodeSigning()
        .bitcodeEnabled(false)
        .otherLinkerFlags(["-ObjC"])
      ,
      configurations: [
        .debug,
        .release
      ],
      defaultSettings: .recommended)

    let schemes: [Scheme] = [
      .makeScheme(target: .debug, name: name),
    ]

    return Project(
      name: name,
      organizationName: "THT",
      packages: packages,
      settings: settings,
      targets: targets,
      schemes: schemes
    )
  }
}
