//
//  InfoPlist.swift
//  MyPlugin
//
//  Created by Kanghos on 2023/11/19.
//

import ProjectDescription

public let infoPlistExtension: [String: InfoPlist.Value] = [
  "CFBundleShortVersionString": "1.0",
  "CFBundleVersion": "1",
  "UILaunchStoryboardName": "LaunchScreen",
  "CFBundleName": "THT",
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

  // MARK: Privacy

  "UIAppFonts": [
    "Item 0": "Pretendard-Medium.otf",
    "Item 1": "Pretendard-Regular.otf",
    "Item 2": "Pretendard-SemiBold.otf",
    "Item 3": "Pretendard-Bold.otf",
    "Item 4": "Pretendard-ExtraBold.otf"
  ],
  "UIUserInterfaceStyle": "Dark"
]

public func infoPlistExtension(name: String) -> [String: InfoPlist.Value] {
  [
    "CFBundleShortVersionString": "1.0",
    "CFBundleVersion": "1",
    "UILaunchStoryboardName": "LaunchScreen",
    "CFBundleName": "\(name)",
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
    "NSAppTransportSecurity": ["NSAllowsArbitraryLoads": true],

    // MARK: Privacy
    "NSContactsUsageDescription": "연락처 사용",
    "NSLocationWhenInUseUsageDescription": "위치 정보 사용",

    // MARK: 수출 규청 알고리즘 통과
    "ITSAppUsesNonExemptEncryption": false,

    "UIAppFonts": [
      "Item 0": "Pretendard-Medium.otf",
      "Item 1": "Pretendard-Regular.otf",
      "Item 2": "Pretendard-SemiBold.otf",
      "Item 3": "Pretendard-Bold.otf",
      "Item 4": "Pretendard-ExtraBold.otf"
    ],
    "UIUserInterfaceStyle": "Dark"
  ]
}
