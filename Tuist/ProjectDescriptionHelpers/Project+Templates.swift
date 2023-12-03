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
		dependencies: [TargetDependency]
	) -> Project {
		
		
		let target = Target(
			name: name,
			platform: .iOS,
			product: .framework,
			bundleId: rootPackagesName + name,
			deploymentTarget: basicDeployment,
			infoPlist: .default,
			sources: ["Src/**/*.swift"],
			resources:  [.glob(pattern: .relativeToRoot("Projects/App/Resources/**"))],
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
		product: Product = .staticLibrary
	) -> Project {
		let target = Target(
			name: name,
			platform: .iOS,
			product: product,
			bundleId: rootPackagesName + name,
			deploymentTarget: basicDeployment,
			infoPlist: .default,
			sources: ["Src/**/*.swift"],
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
	
}
