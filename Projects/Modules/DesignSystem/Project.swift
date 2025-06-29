//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Hoo's MacBookPro on 12/3/23.
//

import ProjectDescription
import ProjectDescriptionHelpers
import MyPlugin


let name = Feature.DesignSystem.rawValue

let target = Target.target(
  name: name,
  destinations: .iOS,
  product: .staticFramework,
  bundleId: rootPackagesName + name,
  deploymentTargets: basicDeployment,
  infoPlist: infoPlistExtension(name: Feature.DesignSystem.rawValue),
  sources: ["Src/**"],
  resources: ["Resources/**"],
  dependencies: [
    .domain,
    .SPM.SnapKit,
    .SPM.Then,
    .SPM.RxGesture,
    .SPM.RxCocoa,
    .SPM.KingFisher,
    .SPM.Lottie,
    .SPM.SVGView
  ]
)

let project = Project(
  name: Feature.DesignSystem.rawValue,
  targets: [target],
  resourceSynthesizers: [
    .custom(
      name: "Lottie",
      parser: .json,
      extensions: ["lottie"]
    ),
    .assets(),
    .fonts(),
  ]
)
