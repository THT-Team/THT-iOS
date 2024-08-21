//
//  Scheme.swift
//  ProjectDescriptionHelpers
//
//  Created by Kanghos on 8/6/24.
//

import Foundation
import ProjectDescription

public extension Scheme {
  static func makeTargetScheme(target: AppConfiguration, name: String) -> Self {
    scheme(name: "\(name)",
           shared: true,
           buildAction: .buildAction(targets: ["\(name)"]),
           testAction: nil,
           runAction: .runAction(configuration: target.configurationName),
           archiveAction: .archiveAction(configuration: target.configurationName),
           profileAction: .profileAction(configuration: target.configurationName),
           analyzeAction: .analyzeAction(configuration: target.configurationName))
  }
  static func makeScheme(target: AppConfiguration, name: String) -> Self {
    scheme(name: "\(name)",
           shared: true,
           buildAction: .buildAction(targets: ["\(name)"]),
           testAction: .targets(["\(name)Tests"],
                                arguments: nil,
                                configuration: target.configurationName,
                                options: .options(coverage: true)),
           runAction: .runAction(configuration: target.configurationName),
           archiveAction: .archiveAction(configuration: target.configurationName),
           profileAction: .profileAction(configuration: target.configurationName),
           analyzeAction: .analyzeAction(configuration: target.configurationName))
  }

  static func makeReleaseScheme(target: AppConfiguration, name: String) -> Self {
    scheme(name: "\(name)",
           shared: true,
           buildAction: .buildAction(targets: ["\(name)"]),
           testAction: nil,
           runAction: .runAction(configuration: target.configurationName),
           archiveAction: .archiveAction(configuration: target.configurationName),
           profileAction: .profileAction(configuration: target.configurationName),
           analyzeAction: .analyzeAction(configuration: target.configurationName))
  }

  static func makeDemoScheme(target: AppConfiguration, name: String) -> Self {
    scheme(name: "\(name)DemoApp",
           shared: true,
           buildAction: .buildAction(targets: ["\(name)DemoApp"]),
           testAction: .targets(["\(name)Tests"],
                                arguments: nil,
                                configuration: target.configurationName,
                                options: .options(coverage: true)),
           runAction: .runAction(configuration: target.configurationName),
           archiveAction: .archiveAction(configuration: target.configurationName),
           profileAction: .profileAction(configuration: target.configurationName),
           analyzeAction: .analyzeAction(configuration: target.configurationName))
  }
}
