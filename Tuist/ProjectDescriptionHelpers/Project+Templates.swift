import Foundation
import ProjectDescription


public let rootPackagesName = "com.tht."
public let basicDeployment: DeploymentTargets = .iOS("17.0")

public extension Project {
  static func staticFramework(
    name: String,
    packages: [Package],
    dependencies: [TargetDependency]
  ) -> Project {
    makeProject(
      name: name,
      packages: packages,
      product: .staticFramework,
      dependencies: dependencies)}

  static func dynamicFramework(
    name: String,
    packages: [Package],
    dependencies: [TargetDependency]
  ) -> Project {
    makeProject(
      name: name,
      packages: packages,
      product: .framework,
      dependencies: dependencies)}
}

public extension Project {
  static func makeProject(
    name: String,
    packages: [Package] = [],
    product: Product,
    dependencies: [TargetDependency]
  ) -> Project {

    let target = Target.target(
      name: name,
      destinations: .iOS,
      product: product,
      bundleId: rootPackagesName + name,
      deploymentTargets: basicDeployment,
      sources: ["Src/**"],
      dependencies: dependencies
    )

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
      .makeScheme(target: .release, name: name)
    ]

    return Project(
      name: name,
      organizationName: "THT",
      packages: packages,
      settings: settings,
      targets: [target],
      schemes: schemes
    )
  }

  static func makeModule(
    name: String,
    dependencies: [TargetDependency],
    product: Product = .staticLibrary
  ) -> Project {

    let target = Target.target(
      name: name,
      destinations: .iOS,
      product: product,
      bundleId: rootPackagesName + name,
      deploymentTargets: basicDeployment,
      sources: ["Src/**"],
      dependencies: dependencies
    )

    return Project(
      name: name,
      organizationName: "THT",
      targets: [target]
    )
  }

  static func designSystem(
    name: String,
    dependencies: [TargetDependency],
    infoPlist: InfoPlist
  ) -> Project {

    let target = Target.target(
      name: name,
      destinations: .iOS,
      product: .staticLibrary,
      bundleId: rootPackagesName + name,
      deploymentTargets: basicDeployment,
      infoPlist: infoPlist,
      sources: ["Src/**"],
      resources: ["Resources/**"],
      dependencies: dependencies
    )

    return Project(
      name: name,
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
  }
}


//
//      .adding(
//      "CODE_SIGN_STYLE", value: "Manual"
//    ).adding(
//      "CODE_SIGN_IDENTITY", value: "iPhone Developer"
//    ).adding(
//      "DEVELOPMENT_TEAM", value: "THT"
//    ).adding(
//      "PRODUCT_BUNDLE_IDENTIFIER", value: rootPackagesName + name
//    ).adding(
//      "PROVISIONING_PROFILE_SPECIFIER", value: "Automatic"
//    ).adding(
//      "SWIFT_VERSION", value: "5"
//    ).adding(
//      "SDKROOT", value: "iphoneos"
//    ).adding(
//      "SUPPORTED_PLATFORMS", value: "iphonesimulator iphoneos"
//    ).adding(
//      "IPHONEOS_DEPLOYMENT_TARGET", value: "12.0"
//    ).adding(
//      "ENABLE_BITCODE", value: "NO"
//    ).adding(
//      "OTHER_LDFLAGS", value: "-ObjC"
//    ).adding(
//      "ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES", value: "YES"
//    ).adding(
//      "LD_RUNPATH_SEARCH_PATHS", value: "$(inherited) @executable_path/Frameworks"
//    ).adding(
//      "LD_DYLIB_INSTALL_NAME_BASE", value: "@rpath"
