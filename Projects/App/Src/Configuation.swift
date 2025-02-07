//
//  Configuation.swift
//  Application
//
//  Created by Kanghos on 12/15/24.
//  Copyright © 2024 tht. All rights reserved.
//

import Foundation

public struct Configuration {
  public static let baseURL = Bundle.main.infoDictionary?["BaseURL"] as? String ?? ""
  public static let kakaoNativeAppKey = Bundle.main.object(forInfoDictionaryKey: "KakaoNativeAppKey") as? String ?? ""
  public static let kakaoMapNativeAppKey = Bundle.main.infoDictionary?["KakaoMapNativeKey"] as? String ?? ""
}
