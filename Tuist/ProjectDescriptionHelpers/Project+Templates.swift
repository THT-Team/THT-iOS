import ProjectDescription


private let rootPackagesName = "com.tht."
private let basicDeployment: DeploymentTarget = .iOS(targetVersion: "16.0", devices: .iphone)

//private let projectSettings: Settings = .settings(
//	base: [
//		"OTHER_LDFLAGS": "-ObjC",
//		"HEADER_SEARCH_PATHS": [
//			"$(inherited)",
//			"$(SRCROOT)/Tuist/Dependencies/SwiftPackageManager/.build/checkouts/gtm-session-fetcher/Sources/Core/Public"
//		]
//	]
//)

public extension Project {

	static func dynamicFramework(
		name: String,
		dependencies: [TargetDependency],
    resources: ResourceFileElements = [.glob(pattern: .relativeToRoot("Projects/App/Resources/**"))],
    infoPlist: InfoPlist = .default
	) -> Project {

		let target = Target(
			name: name,
			platform: .iOS,
			product: .framework,
			bundleId: rootPackagesName + name,
			deploymentTarget: basicDeployment,
			infoPlist: infoPlist,
			sources: "Src/**",
			resources:  resources,
			dependencies: dependencies
			//				settings: projectSettings
		)
		
		return Project(
			name: name,
			//			settings: projectSettings,
			targets: [target]
		)
	}
	
	static func library(
		name: String,
		dependencies: [TargetDependency],
		product: Product = .dynamicLibrary
	) -> Project {
		let target = Target(
			name: name,
			platform: .iOS,
			product: product,
			bundleId: rootPackagesName + name,
			deploymentTarget: basicDeployment,
			infoPlist: .default,
			sources: ["Src/"],
			resources:  [.glob(pattern: .relativeToRoot("Projects/App/Resources/**"))],
			dependencies: dependencies
			//			 settings: projectSettings
		)
		
		return Project(
			name: name,
			//		 settings: projectSettings,
			targets: [target]
		)
	}
	
  static func designSystem(
    name: String,
    dependencies: [TargetDependency],
//    resources: ResourceFileElements = [.glob(pattern: .relativeToRoot("Projects/App/Resources/**"))],
    infoPlist: InfoPlist
  ) -> Project {

    let target = Target(
      name: name,
      platform: .iOS,
      product: .framework,
      bundleId: rootPackagesName + name,
      deploymentTarget: basicDeployment,
      infoPlist: infoPlist,
      sources: "Src/**",
      resources: "Resources/**",
      dependencies: dependencies
      //        settings: projectSettings
    )

    return Project(
      name: name,
      //      settings: projectSettings,
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
