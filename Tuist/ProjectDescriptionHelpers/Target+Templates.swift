//
//  Target+Templates.swift
//  ProjectDescriptionHelpers
//
//  Created by Hoo's MacBookPro on 12/3/23.
//

import ProjectDescription
import MyPlugin

private func makeBundleID(with addition: String) -> String {
	(rootPackagesName + addition).lowercased()
}
//
public extension Target {
//	
//	
//	static func makeApp(
//		name: String,
//		dependencies: [ProjectDescription.TargetDependency]
//	) -> Target {
//    .target(
//      name: name,
//      destinations: .iOS,
//      product: .app,
//      bundleId: rootPackagesName,
//      deploymentTargets: basicDeployment,
//      infoPlist: .default,
//      sources: ["Src/**"],
//      resources: ["Resources/**"],
//      dependencies: dependencies,
//      settings: <#T##Settings?#>, coreDataModels: <#T##[CoreDataModel]#>, environmentVariables: <#T##[String : EnvironmentVariable]#>, launchArguments: <#T##[LaunchArgument]#>, additionalFiles: <#T##[FileElement]#>, buildRules: <#T##[BuildRule]#>, mergedBinaryType: <#T##MergedBinaryType#>, mergeable: <#T##Bool#>, onDemandResourcesTags: <#T##OnDemandResourcesTags?#>
//			name: name,
//      destinations: .iOS,
//			product: .app,
//			bundleId: makeBundleID(with: "app"),
//			deploymentTarget: basicDeployment,
//			infoPlist: .extendingDefault(with: infoPlistExtension(name: name)),
//			sources: sources,
//			resources:  [.glob(pattern: .relativeToRoot("Projects/App/Resources/**"))],
//			dependencies: dependencies
////			settings: projectSettings
//		)
//	}
//
  private static func makeDemoApp(
    name: String,
    sources: SourceFilesList,
    resources: ResourceFileElements? = [],
    dependencies: [TargetDependency]
  ) -> Target {
    .target(
      name: name,
      destinations: .iOS,
      product: .app,
      productName: name,
      bundleId: makeBundleID(with: name),
      deploymentTargets: basicDeployment,
      infoPlist: infoPlistExtension,
      sources: sources,
      resources: resources,
      dependencies: dependencies
    )
//    Target(
//      name: name,
//      platform: .iOS,
//      product: .app,
//      bundleId: makeBundleID(with: "demo." + name + "app"),
//      deploymentTarget: basicDeployment,
//      infoPlist: .extendingDefault(with: infoPlistExtension(name: "Demo\(name)")),
//      sources: sources,
//      resources:  resources,
//      dependencies: dependencies
////      settings: projectSettings
//    )
  }
//
	static func makeFramework(
		name: String,
		sources: ProjectDescription.SourceFilesList,
		dependencies: [ProjectDescription.TargetDependency] = [],
		resources: ProjectDescription.ResourceFileElements? = [],
    product: Product = defaultPackageType
	) -> Target {
    .target(
      name: name,
      destinations: .iOS,
      product: product,
      bundleId: makeBundleID(with: name + ".framework"),
      deploymentTargets: basicDeployment,
      sources: sources,
      resources: resources,
      dependencies: dependencies
      )
	}

	private static func feature(
		implementation featureName: String,
		dependencies: [ProjectDescription.TargetDependency] = [],
		resources: ProjectDescription.ResourceFileElements? = []
	) -> Target {
		.makeFramework(
			name: featureName,
			sources: [ "Src/**" ],
			dependencies: dependencies,
			resources: resources
		)
	}
//
	private static func feature(
		interface featureName: String,
		dependencies: [ProjectDescription.TargetDependency] = [],
		resources: ProjectDescription.ResourceFileElements? = []
	) -> Target {
		.makeFramework(
			name: featureName + "Interface",
			sources: [ "Interface/Src/**" ],
			dependencies: dependencies,
			resources: resources
		)
	}
//
  private static func feature(
    demo featureName: String,
    dependencies: [TargetDependency] = [],
    resources: ResourceFileElements? = []
  ) -> Target {
    .makeDemoApp(
      name: featureName + "Demo",
      sources: [ "Demo/Src/**" ],
      resources: resources,
      dependencies: dependencies
    )
  }
//
	static func feature(
		implementation featureName: Feature,
		dependencies: [ProjectDescription.TargetDependency] = [],
		resources: ProjectDescription.ResourceFileElements? = []
	) -> Target {
		.feature(
			implementation: featureName.rawValue,
			dependencies: dependencies,
			resources: resources
		)
	}
//
	static func feature(
		interface featureName: Feature,
		dependencies: [ProjectDescription.TargetDependency] = [],
		resources: ProjectDescription.ResourceFileElements? = []
	) -> Target {
		.feature(
			interface: featureName.rawValue,
			dependencies: dependencies,
			resources: resources
		)
	}
//
  static func feature(
    demo featureName: Feature,
    dependencies: [TargetDependency] = [],
    resources: ResourceFileElements? = [.glob(pattern: .relativeToRoot("Projects/App/Resources/**"))]
  ) -> Target {
    .feature(
      demo: featureName.rawValue,
      dependencies: dependencies,
      resources: resources
    )
  }

	static func feature(
		dependencies: [ProjectDescription.TargetDependency] = []
	) -> Target {
		.makeFramework(
			name: "Feature",
			sources: "Src/**",
			dependencies: dependencies
		)
	}
}
//
//
