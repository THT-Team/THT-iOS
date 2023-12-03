//
//  BuildType.swift
//  MyPlugin
//
//  Created by Kanghos on 2023/11/19.
//

import ProjectDescription

public enum BuildType {
    case debug
    case release
}

public let buildType: BuildType = {
    Environment.buildTypeRelease.getBoolean(default: false) ? .release : .debug
}()

public var defaultPackageType: ProjectDescription.Product = {
    buildType == .release ? .staticFramework : .framework
}()
