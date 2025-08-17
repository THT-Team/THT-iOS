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

public extension Target {

  private static func makeDemoApp(
    name: String,
    sources: SourceFilesList,
    resources: ResourceFileElements? = [],
    dependencies: [TargetDependency]
  ) -> Target {
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
    
    return .target(
      name: name,
      destinations: .iOS,
      product: .app,
      productName: name,
      bundleId: makeBundleID(with: name),
      deploymentTargets: basicDeployment,
      infoPlist: infoPlistExtension(name: name),
      sources: sources,
      resources: resources,
      dependencies: dependencies,
      settings: settings
    )
  }

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

  static func unitTest(
    feature: Feature,
    dependencies: [TargetDependency]
  ) -> Target {
    .makeFramework(
      name: feature.rawValue + "Test",
      sources: [ "Test/Src/**" ],
      dependencies: dependencies,
      product: .unitTests
    )
  }

  static func testing(
    feature: Feature,
    dependencies: [TargetDependency]
  ) -> Target {
    .makeFramework(
      name: feature.rawValue + "Testing",
      sources: [ "Testing/Src/**" ],
      dependencies: dependencies,
      product: .framework
    )
  }
}
