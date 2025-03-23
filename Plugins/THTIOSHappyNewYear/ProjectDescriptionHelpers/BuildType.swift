//
//  BuildType.swift
//  MyPlugin
//
//  Created by Kanghos on 2023/11/19.
//

import ProjectDescription

public enum BuildType: Sendable {
    case debug
    case release
}

public let buildType: BuildType = {
    Environment.buildTypeRelease.getBoolean(default: false) ? .release : .debug
}()

public let defaultPackageType: ProjectDescription.Product = {
  return .staticLibrary
//    buildType == .release ? .staticFramework : .framework
}()
