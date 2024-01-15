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
  dependencies: [
    .core,
    .external(.RxSwift),
    .external(.RxCocoa),
    .external(.SnapKit),
    .external(.Then),
    .external(.RxGesture),
    .external(.RxKeyboard)
  ],
  infoPlist: .extendingDefault(with: infoPlistExtension(name: Feature.DesignSystem.rawValue))
)
