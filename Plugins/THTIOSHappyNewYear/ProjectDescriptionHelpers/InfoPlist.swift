//
//  InfoPlist.swift
//  MyPlugin
//
//  Created by Kanghos on 2023/11/19.
//

import ProjectDescription

public func infoPlistExtension(name: String) -> InfoPlist {
  .dictionary([
    "CFBundleShortVersionString": "1.0.0",
    "CFBundleVersion": "1",
    "CFBundlePackageType": "APPL",
    "CFBundleExecutable": "$(EXECUTABLE_NAME)",
    "CFBundleIdentifier": "$(PRODUCT_BUNDLE_IDENTIFIER)",
    "CFBundleName": "$(PRODUCT_NAME)",
    "CFBundleDisplayName": "\(name)",
    
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
    
    // MARK: Background Mode
    "UIBackgroundModes": [
      "remote-notification"
    ],
    
    // MARK: Custom Key
    // MARK: KAKAO
    "BaseURL": "$(BASE_URL)",
    "KakaoMapNativeKey": "$(KAKAO_MAP_NATIVE_KEY)",
    "KakaoNativeAppKey": "$(KAKAO_NATIVE_APP_KEY)",
    
    // MARK: AppScheme
    "LSApplicationQueriesSchemes": [
      "kakaokompassauth",
      "kakaotalk",
    ],
    
    "CFBundleURLTypes": [
      [
        "CFBundleTypeRole": "Editor",
        "CFBundleURLSchemes": [
          "kakao$(KAKAO_NATIVE_APP_KEY)"
        ],
      ],
    ],
    
    "UIUserInterfaceStyle": "Dark"
  ]
    .merging(appTargetAttribute(), uniquingKeysWith: { $1 })
  )
}

public func appTargetAttribute() -> [String: Plist.Value] {
  [
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
  ]
}
