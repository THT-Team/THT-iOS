import ProjectDescription
import ProjectDescriptionHelpers
//import ProjectDescriptionHelpers

/*
 +-------------+
 |             |
 |     App     | Contains TuistTest App target and TuistTest unit-test target
 |             |
 +------+-------------+-------+
 |         depends on         |
 |                            |
 +----v-----+                   +-----v-----+
 |          |                   |           |
 |   Kit    |                   |     UI    |   Two independent frameworks to share code and start modularising your app
 |          |                   |           |
 +----------+                   +-----------+

 */

// MARK: - ProjectFactory
protocol ProjectFactory {
  var projectName: String { get }
  //    var dependencies: [TargetDependency] { get }

  func generateTarget() -> [Target]
  //  func generateConfigurations() -> Settings
}

// MARK: - Constants
final class BaseProjectFactory: ProjectFactory {
  let projectName: String = "Falling"
  let organizationName: String = ""
  let bundleID: String = "com.tht.falling.Falling"
  let targetVersion: String = "16.1"

  let dependencies: [TargetDependency] = [
    .external(name: "SnapKit"),
    .external(name: "Then"),
    .external(name: "Starscream"),
    .external(name: "RxSwift"),
    .external(name: "RxKeyboard"),
    .external(name: "SnapKit"),
    .external(name: "Kingfisher"),
    .external(name: "Lottie"),
    .external(name: "Moya"),
//    .external(name: "FirebaseAuth"),
//    .external(name: "FirebaseStorage")
  ]

  let infoPlist: [String: InfoPlist.Value] = [
    "CFBundleName": "THT",
    "CFBundleShortVersionString": "1.0.0",
    "CFBundleVersion": "1",
    "UILaunchStoryboardName": "LaunchScreen",
    "UIApplicationSceneManifest": [
      "UIApplicationSupportsMultipleScenes": false,
      "UISceneConfigurations": [
        "UIWindowSceneSessionRoleApplication": [
          [
            "UISceneConfigurationName": "Default Configuration",
            "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
          ],
        ]
      ]
    ],
    "App Transport Security Settings": ["Allow Arbitrary Loads": true],
    "NSAppTransportSecurity": ["NSAllowsArbitraryLoads": true],
    "UIAppFonts": [
      "Item 0": "Pretendard-Medium.otf",
      "Item 1": "Pretendard-Regular.otf",
      "Item 2": "Pretendard-SemiBold.otf",
      "Item 3": "Pretendard-Bold.otf",
      "Item 4": "Pretendard-ExtraBold.otf"
    ],
    "UIUserInterfaceStyle": "Light"
  ]


  let projectSettings: Settings = .settings(
    base: [
      "OTHER_LDFLAGS": "-ObjC",
      "HEADER_SEARCH_PATHS": [
        "$(inherited)",
        "$(SRCROOT)/../../Tuist/Dependencies/SwiftPackageManager/.build/checkouts/GTMAppAuth/GTMAppAuth/Sources/Public/GTMAppAuth",
        "$(SRCROOT)/../../Tuist/Dependencies/SwiftPackageManager/.build/checkouts/gtm-session-fetcher/Sources/Core/Public"
      ]
    ]
  )

  //  /Users/kanghos/Desktop/iOS/tuist-test/Projects/App/Support
  func generateTarget() -> [Target] {
    return [
      Target(name: projectName,
             platform: .iOS,
             product: .app,
             bundleId: bundleID,
             deploymentTarget: .iOS(targetVersion: targetVersion, devices: [.iphone]),
             infoPlist: .extendingDefault(with: infoPlist),
             sources: ["\(projectName)/Sources/**"],
             resources: ["\(projectName)/Resources/**"],
             dependencies: dependencies,
             settings: projectSettings
            ),

      //            Target(name: "\(projectName)Tests",
      //                   platform: .iOS,
      //                   product: .unitTests,
      //                   bundleId: "com.tht.\(projectName).Tests"
      //                   infoPlist: .default,
      //                   sources: ["\(projectName)/\(projectName)Tests/**"],
      //                   dependencies: [.target(name: projectName)]
      //            )
    ]
  }

  //      func generateConfigurations() -> Settings {
  //          Setting.settings(configurations: [
  //              .debug(name: , xcconfig: ),
  //              .release(name: , xcconfig: )
  //          ])
  //      }
}

// MARK: - Project
let factory = BaseProjectFactory()
let project = Project(name: factory.projectName,
                      organizationName: factory.organizationName,
                      settings: factory.projectSettings,
                      targets: factory.generateTarget()
)


